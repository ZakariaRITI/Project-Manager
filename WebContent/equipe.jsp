<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<%
    User userSession = (User) session.getAttribute("user");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> data = (List<Map<String, Object>>) request.getAttribute("data");
    if (data == null) { data = new ArrayList<>(); }

    // Groupement des données par projet
    Map<Integer, List<Map<String, Object>>> projetsMap = new HashMap<>();
    for (Map<String, Object> row : data) {
        int projetId = (int) row.get("projetId");
        projetsMap.computeIfAbsent(projetId, k -> new ArrayList<>()).add(row);
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Équipes - Project Manager</title>

    <!-- Bootstrap 5 & Google Fonts -->
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
            --danger: #ef4444;
        }

        * { font-family: 'Inter', sans-serif; }
        body { background: var(--bg-body); color: var(--text-dark); margin: 0; }

        /* SIDEBAR STYLE (Identique aux autres pages) */
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

        /* PROJECT TEAM CARD */
        .team-card {
            background: white; border-radius: 16px; border: 1px solid var(--border-light);
            padding: 25px; margin-bottom: 25px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .team-card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .project-name { font-size: 20px; font-weight: 700; color: var(--text-dark); }
        
        .member-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 15px; }
        .member-item {
            background: #f8fafc; border: 1px solid var(--border-light);
            padding: 12px 15px; border-radius: 12px; display: flex; align-items: center; gap: 12px;
        }
        .member-avatar {
            width: 35px; height: 35px; background: var(--accent-primary); color: white;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 700;
        }
        .member-info b { font-size: 14px; display: block; color: var(--text-dark); }
        .member-info span { font-size: 12px; color: var(--text-secondary); }

        .btn-leave {
            background: #fff1f2; color: var(--danger); border: 1px solid #fee2e2;
            padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600;
            transition: 0.2s; text-decoration: none;
        }
        .btn-leave:hover { background: var(--danger); color: white; border-color: var(--danger); }

        .empty-state {
            text-align: center; padding: 60px; background: white; border-radius: 16px;
            border: 1px dashed var(--border-light); color: var(--text-secondary);
        }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-logo">📁 Project Manager</div>
        <nav class="nav-menu">
            <a href="DASHBOARD.jsp" class="nav-item">🏠 Accueil</a>
            <a href="tableauDeBord.jsp" class="nav-item">📊 Dashboard</a>
            <a href="ProjetServlet" class="nav-item">📁 Mes Projets</a>
            <a href="EquipeServlet" class="nav-item active">👥 Équipes</a>
            <a href="profile.jsp" class="nav-item">👤 Profil</a>
        </nav>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="page-header">
            <h1 class="page-title">👥 Projets d'équipe</h1>
        </div>

        <% if (projetsMap.isEmpty()) { %>
            <div class="empty-state">
                <div style="font-size: 40px; margin-bottom: 15px;">📭</div>
                <h4>Aucun projet partagé</h4>
                <p>Les projets dans lesquels vous collaborez avec d'autres membres apparaîtront ici.</p>
            </div>
        <% } %>

        <% 
            for (Integer projetId : projetsMap.keySet()) {
                List<Map<String, Object>> membres = projetsMap.get(projetId);
                // On affiche seulement si c'est un projet d'équipe (au moins 2 personnes)
                if (membres.size() < 2) continue;
                String nomProjet = (String) membres.get(0).get("projetNom");
        %>
            <div class="team-card">
                <div class="team-card-header">
                    <div>
                        <div class="project-name">📁 <%= nomProjet %></div>
                        <div class="text-secondary small">Projet collaboratif actif</div>
                    </div>
                    <form action="EquipeServlet" method="post">
                        <input type="hidden" name="action" value="leave">
                        <input type="hidden" name="projetId" value="<%= projetId %>">
                        <button type="submit" class="btn-leave" onclick="return confirm('Quitter cette équipe ?');">
                            🚪 Quitter l'équipe
                        </button>
                    </form>
                </div>

                <div class="mb-3 mt-4">
                    <h6 style="font-weight: 700; font-size: 13px; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">
                        Membres de l'équipe (<%= membres.size() %>)
                    </h6>
                </div>

                <div class="member-list">
                    <% for (Map<String, Object> m : membres) { 
                        String pnom = (String) m.get("prenom");
                        String initiales = (pnom != null && pnom.length() > 0) ? pnom.substring(0, 1).toUpperCase() : "?";
                    %>
                        <div class="member-item">
                            <div class="member-avatar"><%= initiales %></div>
                            <div class="member-info">
                                <b><%= pnom %></b>
                                <span><%= m.get("email") %></span>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>

</body>
</html>