<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Projet" %>
<%
    Projet p = (Projet) request.getAttribute("projet");
    if (p == null) {
        response.sendRedirect("manageProjets");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Projet | Project Manager</title>
    
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

        /* Sidebar Harmonisée */
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

        /* Content Area */
        .main-content { 
            margin-left: 260px; 
            width: calc(100% - 260px); 
            padding: 40px; 
        }

        .btn-back {
            color: var(--text-muted);
            font-weight: 500;
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            transition: color 0.2s;
        }
        .btn-back:hover { color: var(--primary); }

        /* Card & Form Design */
        .card {
            border: 1px solid #e2e8f0;
            border-radius: var(--radius);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            background: white;
            overflow: hidden;
        }

        .card-header {
            background: white !important;
            padding: 25px;
            border-bottom: 1px solid #f1f5f9;
        }

        .card-header h5 { font-weight: 700; margin: 0; display: flex; align-items: center; gap: 10px; }

        .form-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #d1d5db;
        }

        .form-control:focus {
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            border-color: var(--primary);
        }

        textarea { min-height: 120px; }

        .actions-footer {
            background-color: #f8fafc;
            padding: 20px 25px;
            border-top: 1px solid #f1f5f9;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn-save {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-save:hover { background-color: #4f46e5; color: white; }

        .btn-cancel {
            background-color: white;
            color: var(--text-main);
            border: 1px solid #d1d5db;
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-cancel:hover { background-color: #f1f5f9; }

        .badge-id {
            background: #eef2ff;
            color: var(--primary);
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 6px;
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
        <div class="container-fluid">
            <a href="manageProjets" class="btn-back">
                <i class="fas fa-arrow-left me-2"></i> Retour à la liste des projets
            </a>

            <div class="row">
                <div class="col-xl-8">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-tools text-primary"></i> Modifier le projet</h5>
                            <span class="badge-id fw-bold">ID: #<%= p.getId() %></span>
                        </div>
                        
                        <form action="manageProjets" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= p.getId() %>">

                            <div class="card-body p-4">
                                <div class="row g-4">
                                    <!-- Nom du Projet -->
                                    <div class="col-md-8">
                                        <label class="form-label">Nom du Projet</label>
                                        <input type="text" name="nom" class="form-control" value="<%= p.getNom() %>" required>
                                    </div>

                                    <!-- Statut -->
                                    <div class="col-md-4">
                                        <label class="form-label">Statut Actuel</label>
                                        <select name="statut" class="form-select">
                                            <option value="EN_COURS" <%= "En cours".equalsIgnoreCase(p.getStatut()) ? "selected" : "" %>>En cours</option>
                             
                                            <option value="TERMINE" <%= "Terminé".equalsIgnoreCase(p.getStatut()) ? "selected" : "" %>>Terminé</option>
                                        </select>
                                    </div>

                                    <!-- Description -->
                                    <div class="col-12">
                                        <label class="form-label">Description du projet</label>
                                        <textarea name="description" class="form-control" placeholder="Objectifs et détails du projet..." required><%= p.getDescription() %></textarea>
                                    </div>

                                    <!-- Mot de passe (Optionnel) -->
                                    <div class="col-md-6">
                                        <label class="form-label">Code d'accès <small class="text-muted text-lowercase fw-normal">(Optionnel)</small></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i class="fas fa-lock text-muted"></i></span>
                                            <input type="text" name="motDePasse" class="form-control" value="<%= p.getMotDePasse() != null ? p.getMotDePasse() : "" %>" placeholder="Ex: PROJ-2024">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="actions-footer">
                                <a href="manageProjets" class="btn btn-cancel">Annuler</a>
                                <button type="submit" class="btn btn-save shadow-sm">
                                    <i class="fas fa-save me-2"></i> Enregistrer les modifications
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Info Sidebar -->
                <div class="col-xl-4">
                    <div class="card border-0 bg-light">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="fas fa-info-circle text-primary me-2"></i> Aide à l'édition</h6>
                            <ul class="small text-muted ps-3 mb-0">
                                <li class="mb-2">Le <b>Nom du projet</b> doit être explicite pour les membres de l'équipe.</li>
                                <li class="mb-2">Le passage au statut <b>"Terminé"</b> archivera visuellement le projet pour les utilisateurs.</li>
                                <li>Le <b>Code d'accès</b> est utilisé si vous souhaitez restreindre l'auto-inscription à ce projet.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>