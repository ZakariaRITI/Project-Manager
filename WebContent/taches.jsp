<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Tache" %>
<%@ page import="model.User" %>
<%@ page import="model.Projet" %>
<%
    List<Tache> taches = (List<Tache>) request.getAttribute("taches");
    Integer projetId = (Integer) request.getAttribute("projetId");

    if (projetId == null) {
        response.sendRedirect("ProjetServlet");
        return;
    }

    Integer progress = (Integer) request.getAttribute("progress");
    if (progress == null) progress = 0;
%>

<%
    // Cast explicite pour éviter les erreurs de type Object
    User user = (User) session.getAttribute("user");
    Projet projet = (Projet) request.getAttribute("projet");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tâches du Projet - Project Manager</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-body: #f1f5f9;
            --sidebar-grad: linear-gradient(180deg, #1f2937 0%, #111827 100%);
            --accent-primary: #4f46e5;
            --accent-success: #10b981;
            --accent-warning: #f59e0b;
            --accent-danger: #ef4444;
            --text-dark: #1e293b;
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
        .page-header { margin-bottom: 30px; }

        /* PROGRESS BAR */
        .progress-card {
            background: white; padding: 20px; border-radius: 12px;
            border: 1px solid var(--border-light); margin-bottom: 30px;
        }
        .progress { height: 10px; border-radius: 10px; background: #e2e8f0; }
        .progress-bar { background: linear-gradient(90deg, var(--accent-primary), var(--accent-success)); }

        /* TASK CARDS */
        .task-card {
            background: white; border-radius: 12px; border: 1px solid var(--border-light);
            padding: 20px; margin-bottom: 15px; transition: 0.2s;
            display: flex; justify-content: space-between; align-items: center;
        }
        .task-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }

        /* BADGES & STATUS */
        .badge-status { padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .status-A_FAIRE { background: #fef3c7; color: #92400e; }
        .status-EN_COURS { background: #dbeafe; color: #1e40af; }
        .status-TERMINE { background: #d1fae5; color: #065f46; }

        .prio-HAUTE { color: var(--accent-danger); font-weight: 700; }
        .prio-MOYENNE { color: var(--accent-warning); font-weight: 700; }
        .prio-BASSE { color: var(--accent-success); font-weight: 700; }

        /* FORM BOX */
        .form-box {
            background: white; padding: 25px; border-radius: 12px;
            border: 1px solid var(--border-light); position: sticky; top: 40px;
        }
        .form-control-custom {
            background: #f8fafc; border: 1px solid var(--border-light);
            padding: 10px 15px; border-radius: 8px; width: 100%; margin-bottom: 15px;
            font-size: 14px;
        }

        /* BUTTONS */
        .btn-status {
            font-size: 11px; padding: 6px 10px; border-radius: 6px;
            text-decoration: none; font-weight: 600; color: white; transition: 0.2s;
        }
        .btn-status:hover { opacity: 0.8; color: white; }
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
            <h1 class="fw-bold">📌 Tâches du projet</h1>
            <p class="text-secondary">Gérez l'avancement et les priorités de vos tickets</p>
        </div>

        <!-- PROGRESSION -->
        <div class="progress-card">
            <div class="d-flex justify-content-between mb-2">
                <span class="fw-bold">Progression globale</span>
                <span class="fw-bold text-primary"><%= progress %>%</span>
            </div>
            <div class="progress">
                <div class="progress-bar" role="progressbar" style="width: <%= progress %>%"></div>
            </div>
        </div>

        <div class="row">
            <!-- COLONNE GAUCHE : FORMULAIRE -->
            <div class="col-lg-4">
                <div class="form-box">
                    <h5 class="fw-bold mb-3">➕ Nouvelle tâche</h5>
                    <form action="TacheServlet" method="post">
                        <input type="hidden" name="projetId" value="<%= projetId %>">
                        
                        <label class="small fw-bold text-secondary mb-1">NOM DE LA TÂCHE</label>
                        <input type="text" name="nom" class="form-control-custom" placeholder="Ex: Design de la BDD" required>

                        <label class="small fw-bold text-secondary mb-1">DESCRIPTION</label>
                        <textarea name="description" class="form-control-custom" rows="3" placeholder="Détails du ticket..."></textarea>

                        <label class="small fw-bold text-secondary mb-1">PRIORITÉ</label>
                        <select name="priorite" class="form-control-custom" required>
                            <option value="BASSE">🟢 BASSE</option>
                            <option value="MOYENNE" selected>🟡 MOYENNE</option>
                            <option value="HAUTE">🔴 HAUTE</option>
                        </select>

                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2" style="background: var(--accent-primary); border:none;">
                            Ajouter la tâche
                        </button>
                    </form>
                </div>
            </div>

            <!-- COLONNE DROITE : LISTE -->
            <div class="col-lg-8">
                <%
                    if (taches != null && !taches.isEmpty()) {
                        for (Tache t : taches) {
                %>
                <div class="task-card">
                    <div style="max-width: 60%;">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="badge-status status-<%= t.getStatut() %>">
                                <%= t.getStatut().replace("_", " ") %>
                            </span>
                            <span class="small prio-<%= t.getPriorite() %>">
                                • <%= t.getPriorite() %>
                            </span>
                        </div>
                        <h6 class="fw-bold mb-1"><%= t.getNom() %></h6>
                        <p class="text-secondary small mb-0"><%= (t.getDescription() != null) ? t.getDescription() : "Pas de description" %></p>
                    </div>

                    <div class="text-end">
                    
                        <div class="d-flex gap-1 mb-2 justify-content-end">
                            <a href="TacheServlet?updateStatus=<%= t.getId() %>&status=A_FAIRE&projetId=<%= projetId %>" class="btn-status" style="background: #64748b;">À FAIRE</a>
                            <a href="TacheServlet?updateStatus=<%= t.getId() %>&status=EN_COURS&projetId=<%= projetId %>" class="btn-status" style="background: var(--accent-primary);">EN COURS</a>
                            <a href="TacheServlet?updateStatus=<%= t.getId() %>&status=TERMINE&projetId=<%= projetId %>" class="btn-status" style="background: var(--accent-success);">TERMINÉ</a>
                        </div>
                        <% if (user != null && projet != null && user.getId() == projet.getCreatedBy()) { %>
                        <div>
                            <a href="TacheServlet?edit=<%= t.getId() %>&projetId=<%= projetId %>" class="text-decoration-none small fw-bold me-2" style="color: #a855f7;">Modifier</a>
                            <a href="TacheServlet?delete=<%= t.getId() %>&projetId=<%= projetId %>" 
                               class="text-decoration-none small fw-bold" style="color: var(--accent-danger);"
                               onclick="return confirm('Supprimer cette tâche ?');">Supprimer</a>
                        </div>
                        <% } %>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="text-center py-5">
                    <p class="text-secondary">Aucune tâche enregistrée pour le moment.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

</body>
</html>