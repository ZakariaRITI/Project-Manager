<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String initiales = (user.getPrenom() != null && !user.getPrenom().isEmpty()) 
                       ? user.getPrenom().substring(0, 1).toUpperCase() : "U";
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Project Manager</title>

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

        /* SIDEBAR STYLE */
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
        .page-header { margin-bottom: 30px; }
        .page-title { font-size: 28px; font-weight: 700; }

        /* PROFILE CARD */
        .profile-wrapper { max-width: 600px; }
        .card-profile {
            background: white; border-radius: 16px; border: 1px solid var(--border-light);
            padding: 40px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .profile-avatar-large {
            width: 80px; height: 80px; background: var(--accent-primary); color: white;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 32px; font-weight: 700; margin-bottom: 20px;
        }

        .info-group { margin-bottom: 25px; border-bottom: 1px solid #f1f5f9; padding-bottom: 20px; }
        .info-item { margin-bottom: 10px; font-size: 15px; }
        .info-item b { color: var(--text-secondary); width: 100px; display: inline-block; font-weight: 500; }
        .info-item span { color: var(--text-dark); font-weight: 600; }

        /* FORMS */
        .form-label { font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px; }
        .form-control-custom {
            background: #f8fafc; border: 1px solid var(--border-light);
            padding: 12px 15px; border-radius: 10px; width: 100%; margin-bottom: 20px;
            transition: 0.2s;
        }
        .form-control-custom:focus { outline: none; border-color: var(--accent-primary); background: white; }

        .btn-custom {
            padding: 12px; border-radius: 10px; font-weight: 600; border: none; width: 100%; transition: 0.2s;
        }
        .btn-update { background: var(--accent-primary); color: white; margin-bottom: 15px; }
        .btn-update:hover { opacity: 0.9; transform: translateY(-1px); }
        
        .btn-logout { background: #fff1f2; color: var(--danger); border: 1px solid #fee2e2; }
        .btn-logout:hover { background: var(--danger); color: white; }
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
            <a href="EquipeServlet" class="nav-item">👥 Équipes</a>
            <a href="profile.jsp" class="nav-item active">👤 Profil</a>
        </nav>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="page-header">
            <h1 class="page-title">👤 Mon profil</h1>
            <p class="text-secondary">Gérez vos informations personnelles et vos accès</p>
        </div>

        <div class="profile-wrapper">
            <div class="card-profile">
                
                <!-- HEADER PROFIL -->
                <div class="profile-avatar-large"><%= initiales %></div>
                
                <div class="info-group">
                    <div class="info-item"><b>Nom</b> <span><%= user.getNom() %></span></div>
                    <div class="info-item"><b>Prénom</b> <span><%= user.getPrenom() %></span></div>
                    <div class="info-item"><b>Rôle</b> <span class="badge bg-light text-primary px-3 py-2"><%= user.getRole() %></span></div>
                </div>

                <!-- FORMULAIRE DE MISE À JOUR -->
                <form action="ProfileServlet" method="post">
                    <input type="hidden" name="id" value="<%= user.getId() %>">

                    <div class="mb-3">
                        <label class="form-label">ADRESSE EMAIL ACTUELLE</label>
                        <input type="email" name="email" class="form-control-custom" value="<%= user.getEmail() %>" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">NOUVEAU MOT DE PASSE</label>
                        <input type="password" name="password" class="form-control-custom" placeholder="Laissez vide pour ne pas changer">
                    </div>

                    <button type="submit" class="btn-custom btn-update">💾 Enregistrer les modifications</button>
                </form>

                <!-- DECONNEXION -->
                <form action="LogoutServlet" method="post" class="mt-2">
                    <button type="submit" class="btn-custom btn-logout">🚪 Déconnexion du compte</button>
                </form>

            </div>
        </div>
    </div>

</body>
</html>