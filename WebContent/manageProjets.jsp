<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Projet" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Projets | Project Manager</title>
    
    <!-- Polices et Icones -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --sidebar: #1e293b;
            --sidebar-hover: #334155;
            --primary: #6366f1;
            --success: #10b981;
            --warning: #f59e0b;
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

        /* Sidebar - Design Harmonisé */
        .sidebar { 
            width: 260px; 
            height: 100vh; 
            background: var(--sidebar); 
            color: white; 
            position: fixed; 
            display: flex;
            flex-direction: column;
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
        .sidebar-menu li { margin-bottom: 4px; }
        
        .sidebar-menu li a { 
            display: flex; 
            align-items: center;
            padding: 12px 16px; 
            color: #94a3b8; 
            text-decoration: none; 
            border-radius: 8px;
            transition: all 0.2s; 
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
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .page-header h2 { font-weight: 700; margin: 0; }

        /* Cards & Form */
        .card {
            border: 1px solid #e2e8f0;
            border-radius: var(--radius);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            background: white;
            margin-bottom: 30px;
        }

        .card-header {
            background: transparent !important;
            padding: 20px 25px;
            border-bottom: 1px solid #f1f5f9;
            font-weight: 700;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 10px 15px;
            border: 1px solid #d1d5db;
        }

        /* Table Style */
        .table { margin-bottom: 0; }
        .table thead th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            padding: 15px 25px;
            border-top: none;
        }

        .table tbody td {
            padding: 18px 25px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        /* Status Badges */
        .badge-status {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .bg-encours { background-color: #e0e7ff; color: #4338ca; }
        .bg-termine { background-color: #dcfce7; color: #15803d; }
        .bg-default { background-color: #f1f5f9; color: #475569; }

        .btn-action {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .btn-edit { color: var(--primary); background: #eef2ff; margin-right: 5px; }
        .btn-delete { color: var(--danger); background: #fef2f2; }
        .btn-edit:hover { background: var(--primary); color: white; }
        .btn-delete:hover { background: var(--danger); color: white; }

        .btn-primary { background-color: var(--primary); border: none; font-weight: 600; }
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
            <li><a href="<%= request.getContextPath() %>/manageProjets" class="active"><i class="fas fa-briefcase"></i> Projets</a></li>
            <li><a href="<%= request.getContextPath() %>/EquipeServletAdmin"><i class="fas fa-users-cog"></i> Équipes</a></li>
            <li style="margin-top: auto; padding-bottom: 20px;">
                <a href="<%= request.getContextPath() %>/admin/logout" style="color: var(--danger);">
                    <i class="fas fa-power-off"></i> Déconnexion
                </a>
            </li>
        </ul>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h2>Gestion des Projets</h2>
                <p class="text-muted mb-0">Supervisez et organisez l'ensemble des projets actifs.</p>
            </div>
        </div>

        <!-- Formulaire d'ajout rapide (Quick Add) -->
        

        <!-- Liste des projets -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-list text-primary me-2"></i> Liste des projets</span>
                <span class="badge bg-light text-dark border fw-normal">
                    <%= (request.getAttribute("projetsList") != null) ? ((List)request.getAttribute("projetsList")).size() : 0 %> Projets
                </span>
            </div>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom du Projet</th>
                            <th>Description</th>
                            <th>Statut</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Projet> projets = (List<Projet>) request.getAttribute("projetsList"); 
                            if (projets != null && !projets.isEmpty()) {
                                for (Projet p : projets) {
                                    String badgeClass = "bg-default";
                                    String icon = "fa-clock";
                                    if ("Terminé".equalsIgnoreCase(p.getStatut())) {
                                        badgeClass = "bg-termine";
                                        icon = "fa-check-circle";
                                    } else if ("En cours".equalsIgnoreCase(p.getStatut())) {
                                        badgeClass = "bg-encours";
                                        icon = "fa-spinner fa-spin";
                                    }
                        %>
                        <tr>
                            <td class="text-muted small fw-bold">#<%= p.getId() %></td>
                            <td>
                                <div class="fw-bold text-primary"><%= p.getNom() %></div>
                            </td>
                            <td class="text-muted small" style="max-width: 350px;">
                                <%= (p.getDescription() != null && !p.getDescription().isEmpty()) ? p.getDescription() : "<i>Aucune description fournie</i>" %>
                            </td>
                            <td>
                                <span class="badge-status <%= badgeClass %>">
                                    <i class="fas <%= icon %>" style="font-size: 0.7rem;"></i>
                                    <%= p.getStatut() %>
                                </span>
                            </td>
                            <td class="text-end">
                                <a href="manageProjets?action=edit&id=<%= p.getId() %>" class="btn-action btn-edit" title="Modifier">
                                    <i class="fas fa-pen"></i>
                                </a>
                                <a href="manageProjets?action=delete&id=<%= p.getId() %>" 
                                   class="btn-action btn-delete" 
                                   onclick="return confirm('Voulez-vous vraiment supprimer ce projet ?');"
                                   title="Supprimer">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <div class="text-muted">
                                    <i class="fas fa-folder-open d-block mb-3" style="font-size: 2.5rem; opacity: 0.2;"></i>
                                    Aucun projet n'a encore été créé.
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