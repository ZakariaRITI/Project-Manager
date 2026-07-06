<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.User" %>

<%
    User userSession = (User) session.getAttribute("user");
    if (userSession == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Équipes | Project Manager</title>
    
    <!-- Polices et Icones -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --sidebar: #1e293b;
            --sidebar-hover: #334155;
            --primary: #6366f1;
            --danger: #ef4444;
            --bg: #f8fafc;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --radius: 12px;
        }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg); 
            color: var(--text-main);
            display: flex;
            min-height: 100vh;
            margin: 0;
        }

        /* Sidebar Style */
        .sidebar { 
            width: 260px; 
            height: 100vh; 
            background: var(--sidebar); 
            color: white; 
            position: fixed; 
            z-index: 1000;
        }
        
        .sidebar-header { 
            padding: 30px 25px; 
            font-size: 1.2rem; 
            font-weight: 800; 
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .sidebar-header i { color: var(--primary); }

        .sidebar-menu { list-style: none; padding: 0 15px; margin-top: 10px; }
        .sidebar-menu li a { 
            display: flex; 
            align-items: center;
            padding: 12px 16px; 
            color: #94a3b8; 
            text-decoration: none; 
            border-radius: 8px;
            transition: 0.2s; 
            font-weight: 500;
        }

        .sidebar-menu li a:hover { background: var(--sidebar-hover); color: white; }
        .sidebar-menu li a.active { 
            background: var(--primary); 
            color: white;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
        }
        .sidebar-menu i { width: 25px; font-size: 1.1rem; }

        /* Main Content Area */
        .main-content { 
            margin-left: 260px; 
            width: calc(100% - 260px); 
            padding: 40px; 
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h2 { font-weight: 800; color: var(--text-main); letter-spacing: -0.5px; }
        .page-header p { color: var(--text-muted); }

        /* Card & Table */
        .content-card {
            background: white;
            border-radius: var(--radius);
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .table-container { padding: 0; }

        .custom-table {
            width: 100%;
            margin-bottom: 0;
            vertical-align: middle;
        }

        .custom-table thead th {
            background: #f8fafc;
            padding: 18px 25px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            border-bottom: 1px solid #e2e8f0;
        }

        .custom-table tbody td {
            padding: 20px 25px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.95rem;
        }

        /* Elements Table */
        .project-tag {
            background: #eef2ff;
            color: var(--primary);
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .user-pill {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 35px;
            height: 35px;
            background: #f1f5f9;
            color: var(--text-muted);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .btn-remove {
            color: var(--danger);
            background: #fff1f2;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            transition: 0.2s;
            text-decoration: none;
        }

        .btn-remove:hover {
            background: var(--danger);
            color: white;
            transform: translateY(-1px);
        }

        .empty-state {
            padding: 60px;
            text-align: center;
            color: var(--text-muted);
        }

        .empty-state i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-layer-group"></i> Project Manager
        </div>
        <ul class="sidebar-menu">
            <li><a href="<%= request.getContextPath() %>/admin/dashboard"><i class="fas fa-chart-line"></i> Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/UserServlet?action=list"><i class="fas fa-user-friends"></i> Utilisateurs</a></li>
            <li><a href="<%= request.getContextPath() %>/manageProjets"><i class="fas fa-briefcase"></i> Projets</a></li>
            <li><a href="<%= request.getContextPath() %>/EquipeServletAdmin" class="active"><i class="fas fa-users-cog"></i> Équipes</a></li>
            <li style="margin-top: auto; padding-bottom: 20px;">
                <a href="<%= request.getContextPath() %>/admin/logout" style="color: #fca5a5;">
                    <i class="fas fa-power-off"></i> Déconnexion
                </a>
            </li>
        </ul>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <h2>Attribution des Équipes</h2>
            <p>Gérez les membres affectés à chaque projet académique.</p>
        </div>

        <div class="content-card">
            <div class="table-container">
                <table class="table custom-table">
                    <thead>
                        <tr>
                            <th>Projet Académique</th>
                            <th>Membre de l'équipe</th>
                            <th class="text-end">Actions de modération</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String, Object>> equipes = (List<Map<String, Object>>) request.getAttribute("equipesList");
                            if(equipes != null && !equipes.isEmpty()) {
                                for(Map<String, Object> m : equipes) {
                        %>
                            <tr>
                                <td>
                                    <span class="project-tag">
                                        <i class="fas fa-folder"></i> <%= m.get("projetNom") %>
                                    </span>
                                </td>
                                <td>
                                    <div class="user-pill">
                                        <div class="user-avatar">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div>
                                            <div class="fw-semibold"><%= m.get("userName") %></div>
                                            <div class="small text-muted">ID User: #<%= m.get("userId") %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end">
                                    <a href="EquipeServletAdmin?action=delete&userId=<%= m.get("userId") %>&projetId=<%= m.get("projetId") %>" 
                                       class="btn-remove" 
                                       onclick="return confirm('Retirer <%= m.get("userName") %> du projet ?');">
                                        <i class="fas fa-user-minus me-1"></i> Retirer
                                    </a>
                                </td>
                            </tr>
                        <%      
                                } 
                            } else { 
                        %>
                            <tr>
                                <td colspan="3">
                                    <div class="empty-state">
                                        <i class="fas fa-users-slash"></i>
                                        <h5>Aucune affectation trouvée</h5>
                                        <p class="mb-0">Les étudiants ne se sont pas encore inscrits aux projets.</p>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>