<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Utilisateurs | Project Manager</title>
    
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
            --info: #3b82f6;
            --danger: #ef4444;
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

        /* Sidebar (Identique au Dashboard) */
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

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h2 {
            font-weight: 700;
            font-size: 1.75rem;
            margin: 0;
        }

        /* Modernized Cards */
        .card {
            border: 1px solid #e2e8f0;
            border-radius: var(--radius);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .card-header {
            background-color: white !important;
            border-bottom: 1px solid #e2e8f0;
            padding: 20px 25px;
        }

        .card-header h5 {
            color: var(--text-main);
            font-weight: 700;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 10px 15px;
            border: 1px solid #d1d5db;
        }

        .form-control:focus {
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            border-color: var(--primary);
        }

        /* Table Design */
        .table {
            margin-bottom: 0;
        }

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
            font-size: 0.9rem;
            color: var(--text-main);
            border-bottom: 1px solid #f1f5f9;
        }

        .badge-role {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            margin: 0 2px;
        }

        .btn-add {
            background-color: var(--primary);
            border: none;
            padding: 10px 20px;
            font-weight: 600;
        }
        
        .btn-add:hover { background-color: #4f46e5; }
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
        <div class="page-header">
            <h2>Gestion des Utilisateurs</h2>
            <p class="text-muted">Gérez les accès et les rôles des membres de la plateforme.</p>
        </div>

        <!-- Formulaire d'ajout -->
        <div class="card shadow-sm">
            <div class="card-header">
                <h5><i class="fas fa-user-plus text-primary"></i> Ajouter un nouvel utilisateur</h5>
            </div>
            <div class="card-body p-4">
                <form action="<%= request.getContextPath() %>/UserServlet?action=add" method="POST" class="row g-3 align-items-end">
                    <div class="col-md-2">
                        <label class="form-label text-muted small fw-bold">NOM</label>
                        <input type="text" name="nom" class="form-control" placeholder="Ex: Dupont" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label text-muted small fw-bold">PRÉNOM</label>
                        <input type="text" name="prenom" class="form-control" placeholder="Ex: Jean" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">EMAIL</label>
                        <input type="email" name="email" class="form-control" placeholder="jean@example.com" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label text-muted small fw-bold">MOT DE PASSE</label>
                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label text-muted small fw-bold">RÔLE</label>
                        <select name="role" class="form-select">
                            <option value="USER">Utilisateur (User)</option>
                            <option value="ADMIN">Administrateur</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <button type="submit" class="btn btn-primary btn-add w-100">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Table des utilisateurs -->
        <div class="card shadow-sm">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5><i class="fas fa-list text-primary"></i> Liste des membres</h5>
                <span class="badge bg-light text-dark border"><%= (request.getAttribute("usersList") != null) ? ((List)request.getAttribute("usersList")).size() : 0 %> utilisateurs</span>
            </div>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Membre</th>
                            <th>Email</th>
                            <th>Rôle</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<User> users = (List<User>) request.getAttribute("usersList");
                            if (users != null && !users.isEmpty()) {
                                for (User u : users) {
                        %>
                        <tr>
                            <td class="text-muted fw-medium">#<%= u.getId() %></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 38px; height: 38px; font-weight: 700; color: var(--primary); border: 1px solid #e2e8f0;">
                                        <%= u.getNom().substring(0,1).toUpperCase() %>
                                    </div>
                                    <div>
                                        <div class="fw-bold"><%= u.getNom() %> <%= u.getPrenom() %></div>
                                    </div>
                                </div>
                            </td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <% if("ADMIN".equals(u.getRole())) { %>
                                    <span class="badge badge-role bg-danger-subtle text-danger">ADMIN</span>
                                <% } else { %>
                                    <span class="badge badge-role bg-primary-subtle text-primary">USER</span>
                                <% } %>
                            </td>
                            <td class="text-end">
                                <a href="<%= request.getContextPath() %>/UserServlet?action=editPage&id=<%= u.getId() %>" 
                                   class="btn btn-action btn-outline-info">
                                   <i class="fas fa-edit"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/UserServlet?action=delete&id=<%= u.getId() %>" 
                                   class="btn btn-action btn-outline-danger" 
                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')">
                                   <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">
                                <i class="fas fa-user-slash d-block mb-3" style="font-size: 2rem; opacity: 0.3;"></i>
                                Aucun utilisateur trouvé dans la base de données.
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