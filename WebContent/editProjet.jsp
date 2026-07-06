<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Projet" %>

<%
    Projet projet = (Projet) request.getAttribute("projet");
    if (projet == null) {
        response.sendRedirect("ProjetServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le Projet - Project Manager</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-body: #f1f5f9;
            --sidebar-grad: linear-gradient(180deg, #1f2937 0%, #111827 100%);
            --accent-primary: #4f46e5;
            --accent-success: #22c55e;
            --text-dark: #1a202c;
            --text-secondary: #64748b;
            --border-light: #e2e8f0;
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
        .page-title { font-size: 28px; font-weight: 700; margin-bottom: 5px; }

        /* FORM BOX */
        .edit-wrapper { max-width: 650px; }
        .form-box {
            background: white; padding: 40px; border-radius: 16px; 
            border: 1px solid var(--border-light);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .form-label {
            font-size: 13px; font-weight: 600; color: var(--text-secondary);
            margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px;
        }

        .form-control-custom {
            background: #f8fafc; border: 1px solid var(--border-light);
            padding: 12px 15px; border-radius: 10px; width: 100%; margin-bottom: 25px;
            transition: 0.2s; font-size: 15px;
        }
        .form-control-custom:focus { outline: none; border-color: var(--accent-primary); background: white; }

        /* BUTTONS */
        .btn-save {
            background: var(--accent-success); color: white; border: none;
            padding: 14px; border-radius: 10px; font-weight: 600; width: 100%;
            transition: 0.2s; cursor: pointer;
        }
        .btn-save:hover { opacity: 0.9; transform: translateY(-1px); }

        .btn-back {
            display: inline-flex; align-items: center; gap: 8px;
            color: var(--text-secondary); text-decoration: none;
            font-size: 14px; font-weight: 500; margin-bottom: 20px;
            transition: 0.2s;
        }
        .btn-back:hover { color: var(--accent-primary); }
    </style>
</head>

<body>

    <!-- SIDEBAR -->
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

    <!-- MAIN CONTENT -->
    <div class="main-content">
        
        <a href="ProjetServlet" class="btn-back">⬅ Retour à la liste</a>

        <div class="page-header">
            <h1 class="page-title">✏️ Modifier le Projet</h1>
            <p class="text-secondary">Mettez à jour les détails de votre projet collaboratif</p>
        </div>

        <div class="edit-wrapper">
            <div class="form-box">
                <form action="ProjetServlet" method="post">
                    
                    <!-- ID caché -->
                    <input type="hidden" name="id" value="<%= projet.getId() %>">

                    <div class="mb-1">
                        <label class="form-label">Nom du projet</label>
                        <input type="text" name="nom" class="form-control-custom" 
                               value="<%= projet.getNom() %>" required placeholder="Ex: Développement API Java">
                    </div>

                    <div class="mb-1">
                        <label class="form-label">Description détaillée</label>
                        <textarea name="description" class="form-control-custom" rows="4" 
                                  placeholder="Expliquez brièvement l'objectif du projet..."><%= (projet.getDescription() != null) ? projet.getDescription() : "" %></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Statut du projet</label>
                        <select name="statut" class="form-control-custom">
                            <option value="EN_COURS" <%= "EN_COURS".equals(projet.getStatut()) ? "selected" : "" %>>🚀 EN COURS</option>
                            <option value="TERMINE" <%= "TERMINE".equals(projet.getStatut()) ? "selected" : "" %>>✅ TERMINÉ</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-save">💾 Sauvegarder les modifications</button>

                </form>
            </div>
        </div>
    </div>

</body>
</html>