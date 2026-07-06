<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Projet" %>
<%@ page import="dao.ProjetDAO" %>
<%@ page import="java.util.ArrayList" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ProjetDAO projetDAO = new ProjetDAO();
    List<Projet> projets = projetDAO.getAllProjets();
    
    String searchNom = request.getParameter("searchNom");
    String filterStatut = request.getParameter("filterStatut");
    
    if ((searchNom != null && !searchNom.isEmpty()) || (filterStatut != null && !filterStatut.isEmpty())) {
        List<Projet> projetsFiltres = new ArrayList<>();
        for (Projet p : projets) {
            boolean matchNom = searchNom == null || searchNom.isEmpty() || 
                              p.getNom().toLowerCase().contains(searchNom.toLowerCase());
            boolean matchStatut = filterStatut == null || filterStatut.isEmpty() || 
                                 filterStatut.equals("TOUS") || 
                                 p.getStatut().equals(filterStatut);
            if (matchNom && matchStatut) {
                projetsFiltres.add(p);
            }
        }
        projets = projetsFiltres;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Projets - Project Manager</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-light: #f8f9fa;
            --bg-white: #ffffff;
            --text-dark: #1a202c;
            --text-secondary: #64748b;
            --accent-primary: #4f46e5;
            --accent-secondary: #10b981;
            --border-light: #e2e8f0;
            --error: #ef4444;
            --status-pending: #f59e0b;
            --status-progress: #10b981;
            --status-done: #3b82f6;
        }

        * { font-family: 'Inter', sans-serif; }
        body { background: #f1f5f9; color: var(--text-dark); margin: 0; }

        /* SIDEBAR STYLE */
        .sidebar {
            position: fixed; left: 0; top: 0; width: 280px; height: 100vh;
            background: linear-gradient(180deg, #1f2937 0%, #111827 100%);
            padding: 32px 24px; color: white; z-index: 100;
        }

        .sidebar-logo {
            font-size: 22px; font-weight: 700; display: flex; align-items: center; gap: 10px; margin-bottom: 30px;
        }

        .profile-card {
            background: rgba(255, 255, 255, 0.1); border-radius: 12px; padding: 15px; margin-bottom: 30px;
        }

        .profile-avatar {
            width: 40px; height: 40px; background: var(--accent-primary); border-radius: 50%;
            display: flex; align-items: center; justify-content: center; font-weight: bold; margin-bottom: 10px;
        }

        .nav-menu { display: flex; flex-direction: column; gap: 5px; }
        .nav-item {
            padding: 12px 15px; border-radius: 8px; color: rgba(255,255,255,0.7);
            text-decoration: none; font-size: 14px; transition: 0.2s;
        }
        .nav-item:hover, .nav-item.active { background: rgba(255,255,255,0.1); color: white; }

        /* MAIN CONTENT */
        .main-content { margin-left: 280px; padding: 40px; }

        .page-title { font-size: 28px; font-weight: 700; margin-bottom: 25px; }

        /* CARDS & FILTERS */
        .filter-bar {
            background: white; padding: 20px; border-radius: 12px; border: 1px solid var(--border-light);
            margin-bottom: 30px; display: flex; gap: 15px; align-items: flex-end;
        }

        .project-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px;
        }

        .project-card {
            background: white; border-radius: 15px; padding: 25px; border: 1px solid var(--border-light);
            transition: 0.3s; position: relative;
        }
        .project-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); }

        .status-badge {
            font-size: 11px; font-weight: 700; padding: 5px 10px; border-radius: 6px; text-transform: uppercase;
        }
        .status-EN_COURS { background: rgba(16, 185, 129, 0.1); color: var(--status-progress); }
        .status-TERMINE { background: rgba(59, 130, 246, 0.1); color: var(--status-done); }

        .btn-primary-custom {
            background: var(--accent-primary); color: white; border: none; padding: 10px 20px;
            border-radius: 8px; font-weight: 600; transition: 0.2s;
        }
        .btn-primary-custom:hover { background: #4338ca; opacity: 0.9; }

        .form-control-custom {
            border: 1px solid var(--border-light); padding: 10px; border-radius: 8px; width: 100%;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-logo">📁 Project Manager</div>
        <div class="profile-card">
            <div class="profile-avatar"><%= user.getPrenom().substring(0,1) %></div>
            <div style="font-size: 14px; font-weight: 600;"><%= user.getPrenom() %> <%= user.getNom() %></div>
            <div style="font-size: 12px; opacity: 0.7;"><%= user.getEmail() %></div>
        </div>
        <nav class="nav-menu">
            <a href="DASHBOARD.jsp" class="nav-item active">🏠 Accueil</a>
            <a href="tableauDeBord.jsp" class="nav-item">📊 DASHBOARD</a>
            <a href="ProjetServlet" class="nav-item">📁 Mes Projets</a>
            <a href="EquipeServlet" class="nav-item">👥 Équipes</a>
            <a href="profile.jsp" class="nav-item">👤 Profil</a>
        </nav>
        <hr style="border-top: 1px solid rgba(255,255,255,0.1); margin: 20px 0;">
<form action="LogoutServlet" method="POST">
    <button type="submit" style="width: 100%; background: #ef4444; color: white; border: none; padding: 10px; border-radius: 8px; font-weight: 600; cursor: pointer;">
        Déconnexion
    </button>
</form>
    </div>

    <div class="main-content">
        <h2 class="page-title">📁 Explorer les Projets</h2>

        <!-- Barre de recherche -->
        <form method="GET" class="filter-bar">
            <div style="flex: 2;">
                <label style="font-size: 12px; font-weight: 600;">RECHERCHE</label>
                <input type="text" name="searchNom" class="form-control-custom" placeholder="Nom du projet..." value="<%= searchNom != null ? searchNom : "" %>">
            </div>
            <div style="flex: 1;">
                <label style="font-size: 12px; font-weight: 600;">STATUT</label>
                <select name="filterStatut" class="form-control-custom">
                    <option value="TOUS">Tous</option>
                    <option value="EN_COURS" <%= "EN_COURS".equals(filterStatut) ? "selected" : "" %>>En cours</option>
                    <option value="TERMINE" <%= "TERMINE".equals(filterStatut) ? "selected" : "" %>>Terminé</option>
                </select>
            </div>
            <button type="submit" class="btn-primary-custom">Filtrer</button>
        </form>
		<%-- Zone d'affichage des messages Flash --%>
<div class="container-fluid px-4 mt-3">
    <% 
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        
        if (success != null) { 
    %>
        <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 10px; border: none; background-color: #d1e7dd; color: #0f5132;">
            <strong>Succès !</strong> <%= success %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% 
        session.removeAttribute("success"); 
        } 
    %>

    <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius: 10px; border: none; background-color: #f8d7da; color: #842029;">
            <strong>Erreur !</strong> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% 
        session.removeAttribute("error"); 
        } 
    %>
</div>
        <div class="project-grid">
            <% if (projets != null && !projets.isEmpty()) { 
                for (Projet p : projets) { %>
                <div class="project-card">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                        <h4 style="margin: 0; font-size: 18px;"><%= p.getNom() %></h4>
                        <span class="status-badge status-<%= p.getStatut() %>"><%= p.getStatut() %></span>
                    </div>
                    <p style="color: var(--text-secondary); font-size: 14px; height: 45px; overflow: hidden;">
                        <%= p.getDescription() != null ? p.getDescription() : "Aucune description." %>
                    </p>
                    <hr style="border-color: var(--border-light); margin: 20px 0;">
                    <div style="text-align: right;">
                        <button class="btn-primary-custom" onclick="joinProject(<%= p.getId() %>, '<%= p.getMotDePasse() != null ? p.getMotDePasse() : "" %>')">
                            Rejoindre +
                        </button>
                    </div>
                </div>
            <% } } else { %>
                <div style="grid-column: 1/-1; text-align: center; padding: 50px; opacity: 0.5;">
                    <h3>📭 Aucun projet trouvé</h3>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        function joinProject(projectId, password) {
            let passInput = "";
            if (password && password.trim() !== "") {
                passInput = prompt("🔒 Ce projet est privé. Entrez le mot de passe :");
                if (passInput === null) return;
            }

            let form = document.createElement("form");
            form.method = "POST";
            form.action = "ProjetServlet";
            
            const params = { action: "join", projetId: projectId, motDePasse: passInput };
            for (let key in params) {
                let input = document.createElement("input");
                input.type = "hidden";
                input.name = key;
                input.value = params[key];
                form.appendChild(input);
            }
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
</html>