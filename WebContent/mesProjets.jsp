<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Projet" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Projet> projets = (List<Projet>) request.getAttribute("projets");
    if (projets == null) {
        response.sendRedirect("ProjetServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Projets - Project Manager</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-body: #f1f5f9;
            --sidebar-grad: linear-gradient(180deg, #1f2937 0%, #111827 100%);
            --accent-primary: #4f46e5;
            --text-dark: #1a202c;
            --text-secondary: #64748b;
            --border-light: #e2e8f0;
        }

        * { font-family: 'Inter', sans-serif; }
        body { background: var(--bg-body); color: var(--text-dark); margin: 0; }

        /* SIDEBAR */
        .sidebar {
            position: fixed; left: 0; top: 0; width: 280px; height: 100vh;
            background: var(--sidebar-grad); padding: 32px 24px; color: white; z-index: 100;
        }
        .sidebar-logo { font-size: 22px; font-weight: 700; display: flex; align-items: center; gap: 10px; margin-bottom: 30px; }
        .nav-menu { display: flex; flex-direction: column; gap: 5px; }
        .nav-item {
            padding: 12px 15px; border-radius: 8px; color: rgba(255,255,255,0.7);
            text-decoration: none; font-size: 14px; transition: 0.2s;
        }
        .nav-item:hover, .nav-item.active { background: rgba(255,255,255,0.1); color: white; }

        /* MAIN CONTENT */
        .main-content { margin-left: 280px; padding: 40px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-title { font-size: 28px; font-weight: 700; margin: 0; }

        /* FORM BOX */
        .form-box {
            background: white; padding: 25px; border-radius: 16px; 
            border: 1px solid var(--border-light); margin-bottom: 40px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .form-title { font-size: 16px; font-weight: 700; margin-bottom: 20px; color: var(--text-dark); }
        
        .form-control-custom {
            background: #f8fafc; border: 1px solid var(--border-light);
            padding: 12px; border-radius: 10px; font-size: 14px; margin-bottom: 15px;
        }
        .form-control-custom:focus { outline: none; border-color: var(--accent-primary); background: white; }

        .btn-add {
            background: var(--accent-primary); color: white; border: none;
            padding: 12px; border-radius: 10px; font-weight: 600; width: 100%;
        }

        /* PROJECT CARDS */
        .project-card {
            background: white; border-radius: 16px; border: 1px solid var(--border-light);
            padding: 20px; margin-bottom: 15px; display: flex; justify-content: space-between;
            align-items: center; transition: 0.2s;
        }
        .project-card:hover { transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }

        .project-info h5 { font-weight: 700; margin-bottom: 4px; color: var(--text-dark); }
        .project-info p { color: var(--text-secondary); font-size: 14px; margin-bottom: 10px; }

        .status-badge {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            padding: 4px 12px; border-radius: 20px; letter-spacing: 0.5px;
        }
        .status-active { background: #dcfce7; color: #166534; }

        /* ACTION BUTTONS */
        .action-btns { display: flex; gap: 8px; }
        .btn-action {
            padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600;
            text-decoration: none; transition: 0.2s; border: none;
        }
        .btn-tasks { background: #eef2ff; color: var(--accent-primary); }
        .btn-edit { background: #fef3c7; color: #92400e; }
        .btn-delete { background: #fee2e2; color: #991b1b; }
        
        .btn-action:hover { opacity: 0.8; color: inherit; }
    </style>
</head>

<body>

    <div class="sidebar">
        <div class="sidebar-logo">📁 Project Manager</div>
        <nav class="nav-menu">
            <a href="DASHBOARD.jsp" class="nav-item">🏠 Accueil</a>
            <a href="tableauDeBord.jsp" class="nav-item">📊 Dashboard</a>
            <a href="ProjetServlet" class="nav-item active">📁 Mes Projets</a>
            <a href="EquipeServlet" class="nav-item">👥 Équipes</a>
            <a href="profile.jsp" class="nav-item">👤 Profil</a>
        </nav>
    </div>

    <div class="main-content">
        <div class="page-header">
            <h1 class="page-title">📁 Mes projets</h1>
            <a href="DASHBOARD.jsp" class="text-secondary text-decoration-none small">⬅ Retour</a>
        </div>

        <!-- FORMULAIRE D'AJOUT -->
        <div class="form-box">
            <div class="form-title">Créer un nouveau projet</div>
            <form action="ProjetServlet" method="post" class="row g-2">
                <div class="col-md-4">
                    <input type="text" name="nom" class="form-control-custom w-100" placeholder="Nom du projet" required>
                </div>
                <div class="col-md-4">
                    <input type="password" name="motDePasse" class="form-control-custom w-100" placeholder="Mot de passe (optionnel)">
                </div>
                <div class="col-md-4">
                    <button class="btn-add">➕ Ajouter le projet</button>
                </div>
                <div class="col-12">
                    <textarea name="description" class="form-control-custom w-100" placeholder="Description courte du projet..." rows="2"></textarea>
                </div>
            </form>
        </div>

        <!-- LISTE DES PROJETS -->
       <% for (Projet p : projets) { %>
    <div class="project-card">
        <div class="project-info">
            <h5><%= p.getNom() %></h5>
            <p><%= (p.getDescription() != null && !p.getDescription().isEmpty()) ? p.getDescription() : "Aucune description fournie." %></p>
            <span class="status-badge status-active"><%= p.getStatut() %></span>
        </div>

        <div class="action-btns">
            <!-- Le bouton Tâches reste visible pour tout le monde (membres et proprio) -->
            <a href="TacheServlet?projetId=<%= p.getId() %>" class="btn-action btn-tasks">📌 Tâches</a>
			
            <%-- CONDITION : Seul le créateur peut modifier ou supprimer --%>
            <% if (user.getId() == p.getCreatedBy()) { %>
                <a href="ProjetServlet?action=edit&id=<%= p.getId() %>" class="btn-action btn-edit">✏️ Modifier</a>
                <a href="ProjetServlet?action=delete&id=<%= p.getId() %>" 
                   class="btn-action btn-delete" 
                   onclick="return confirm('Supprimer définitivement ce projet ?');">
                   🗑️ Supprimer
                </a>
            <% } %>
        </div>
    </div>
<% } %>
    </div>

</body>
</html>