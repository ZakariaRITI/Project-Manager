<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Utilisateur | Project Manager</title>
    
    <!-- Polices et Icones -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --sidebar: #1e293b;
            --sidebar-hover: #334155;
            --primary: #6366f1;
            --bg: #f8fafc;
            --card-bg: #ffffff;
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
            -webkit-font-smoothing: antialiased;
        }

        /* Sidebar - Identique aux autres pages */
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
            letter-spacing: 0.5px;
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
            font-size: 0.95rem;
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
            transition: color 0.2s;
            margin-bottom: 20px;
            display: inline-block;
        }
        .btn-back:hover { color: var(--primary); }

        /* Card Style */
        .card {
            border: 1px solid #e2e8f0;
            border-radius: var(--radius);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            background: white;
        }

        .card-header {
            background: transparent !important;
            padding: 25px;
            border-bottom: 1px solid #f1f5f9;
        }

        .card-header h5 {
            font-weight: 700;
            margin: 0;
            color: var(--text-main);
        }

        .form-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #d1d5db;
            transition: all 0.2s;
        }

        .form-control:focus {
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            border-color: var(--primary);
        }

        .btn-save {
            background-color: var(--primary);
            border: none;
            padding: 12px 25px;
            font-weight: 600;
            border-radius: 8px;
            transition: transform 0.2s;
        }

        .btn-save:hover {
            background-color: #4f46e5;
            transform: translateY(-1px);
        }

        .btn-cancel {
            background-color: #f1f5f9;
            color: var(--text-main);
            border: none;
            padding: 12px 25px;
            font-weight: 600;
            border-radius: 8px;
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
            <li><a href="<%= request.getContextPath() %>/UserServlet?action=list" class="active"><i class="fas fa-user-friends"></i> Utilisateurs</a></li>
            <li><a href="<%= request.getContextPath() %>/manageProjets"><i class="fas fa-briefcase"></i> Projets</a></li>
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
            <a href="<%= request.getContextPath() %>/UserServlet?action=list" class="btn-back text-decoration-none">
                <i class="fas fa-arrow-left me-2"></i> Retour à la liste des membres
            </a>

            <div class="row">
                <div class="col-xl-8">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h5><i class="fas fa-user-edit text-primary me-2"></i> Modifier le profil utilisateur</h5>
                        </div>
                        <div class="card-body p-4">
                            <%
                                User u = (User) request.getAttribute("userToEdit");
                                if (u != null) {
                            %>
                            <form action="<%= request.getContextPath() %>/UserServlet?action=update" method="POST">
                                <input type="hidden" name="id" value="<%= u.getId() %>">

                                <div class="row g-4 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Nom de famille</label>
                                        <input type="text" name="nom" class="form-control" value="<%= u.getNom() %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Prénom</label>
                                        <input type="text" name="prenom" class="form-control" value="<%= u.getPrenom() %>" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Adresse Email Professionnelle</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="far fa-envelope text-muted"></i></span>
                                        <input type="email" name="email" class="form-control border-start-0" value="<%= u.getEmail() %>" required>
                                    </div>
                                </div>

                                <div class="mb-5">
                                    <label class="form-label">Rôle & Permissions</label>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <select name="role" class="form-select">
                                                <option value="USER" <%= "USER".equals(u.getRole()) ? "selected" : "" %>>Utilisateur classique</option>
                                                <option value="ADMIN" <%= "ADMIN".equals(u.getRole()) ? "selected" : "" %>>Administrateur</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6 d-flex align-items-center">
                                            <small class="text-muted"><i class="fas fa-info-circle me-1"></i> Les administrateurs ont un accès complet à la gestion.</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-3 pt-3 border-top">
                                    <a href="<%= request.getContextPath() %>/UserServlet?action=list" class="btn btn-cancel">Annuler</a>
                                    <button type="submit" class="btn btn-primary btn-save px-5">
                                        <i class="fas fa-check me-2"></i> Enregistrer les modifications
                                    </button>
                                </div>
                            </form>
                            <% 
                                } else { 
                            %>
                            <div class="text-center py-5">
                                <div class="mb-3">
                                    <i class="fas fa-search text-muted" style="font-size: 3rem; opacity: 0.3;"></i>
                                </div>
                                <h5 class="text-muted">Utilisateur introuvable</h5>
                                <p class="small text-muted">Le membre que vous essayez de modifier n'existe pas ou a été supprimé.</p>
                                <a href="<%= request.getContextPath() %>/UserServlet?action=list" class="btn btn-primary mt-3">Retourner à la liste</a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Panneau latéral d'info (Optionnel pour remplir l'espace sur large écran) -->
                <div class="col-xl-4 d-none d-xl-block">
                    <div class="card bg-primary text-white border-0" style="background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%) !important;">
                        <div class="card-body p-4 text-center">
                            <i class="fas fa-shield-alt mb-3" style="font-size: 2.5rem; opacity: 0.8;"></i>
                            <h5 class="fw-bold">Sécurité du Compte</h5>
                            <p class="small opacity-75">Toute modification de rôle impacte immédiatement les permissions de l'utilisateur sur les projets et les équipes.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>