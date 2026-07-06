<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Projet" %>
<%@ page import="model.Tache" %>
<%@ page import="dao.ProjetDAO" %>
<%@ page import="dao.TacheDAO" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ProjetDAO projetDAO = new ProjetDAO();
    TacheDAO tacheDAO = new TacheDAO();
    List<Projet> projets = projetDAO.getProjetsByUser(user.getId());

    // --- LOGIQUE DE CALCUL DES STATISTIQUES ---
    int totalProjets = projets.size();
    int projetEnCours = 0;
    int projetTermine = 0;
    int totalTaches = 0;
    int tachesTerminees = 0;
    int tachesEnCours = 0;
    int tachesAfaire = 0;
    
    for (Projet p : projets) {
        if ("EN_COURS".equals(p.getStatut())) projetEnCours++;
        else if ("TERMINE".equals(p.getStatut())) projetTermine++;
        
        List<Tache> taches = tacheDAO.getTachesByProjet(p.getId());
        totalTaches += taches.size();
        for (Tache t : taches) {
            if ("TERMINE".equals(t.getStatut())) tachesTerminees++;
            else if ("EN_COURS".equals(t.getStatut())) tachesEnCours++;
            else if ("A_FAIRE".equals(t.getStatut())) tachesAfaire++;
        }
    }

    double percentTermine = totalProjets > 0 ? (projetTermine * 100.0 / totalProjets) : 0;
    double percentEnCours = totalProjets > 0 ? (projetEnCours * 100.0 / totalProjets) : 0;
    double tauxCompletionTaches = totalTaches > 0 ? (tachesTerminees * 100.0 / totalTaches) : 0;
    double moyTachesParProjet = totalProjets > 0 ? (totalTaches * 1.0 / totalProjets) : 0;
    double tauxTachesRestantes = totalTaches > 0 ? ((tachesAfaire + tachesEnCours) * 100.0 / totalTaches) : 0;
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Project Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>

    <style>
        :root {
            --bg-body: #f8fafc;
            --sidebar-grad: linear-gradient(180deg, #1f2937 0%, #111827 100%);
            --accent-primary: #4f46e5;
            --text-dark: #1e293b;
            --text-secondary: #64748b;
            --border-light: #e2e8f0;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
        }

        * { font-family: 'Inter', sans-serif; box-sizing: border-box; }
        body { background: var(--bg-body); color: var(--text-dark); margin: 0; }

        /* SIDEBAR */
        .sidebar {
            position: fixed; left: 0; top: 0; width: 260px; height: 100vh;
            background: var(--sidebar-grad); padding: 32px 24px; color: white; z-index: 1000;
        }
        .sidebar-logo { font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 10px; margin-bottom: 40px; }
        .nav-menu { display: flex; flex-direction: column; gap: 8px; }
        .nav-item {
            padding: 12px 16px; border-radius: 10px; color: rgba(255,255,255,0.7);
            text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s;
        }
        .nav-item:hover, .nav-item.active { background: rgba(255,255,255,0.1); color: white; }
        .nav-item.active { background: var(--accent-primary); box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3); }

        /* MAIN CONTENT */
        .main-content { margin-left: 260px; padding: 40px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-title { font-size: 26px; font-weight: 700; color: var(--text-dark); }

        /* KPI CARDS */
        .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .kpi-card {
            background: white; padding: 24px; border-radius: 16px; 
            border: 1px solid var(--border-light); box-shadow: var(--card-shadow);
        }
        .kpi-label { font-size: 13px; color: var(--text-secondary); font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .kpi-value { font-size: 28px; font-weight: 700; color: var(--text-dark); }
        .kpi-sub { font-size: 12px; color: var(--accent-primary); margin-top: 5px; font-weight: 500; }

        /* PROGRESS BAR */
        .progress { height: 6px; background: #f1f5f9; border-radius: 10px; margin-top: 12px; }
        .progress-bar { background: var(--accent-primary); border-radius: 10px; }

        /* CHARTS SECTION */
        .charts-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .chart-card {
            background: white; padding: 25px; border-radius: 16px;
            border: 1px solid var(--border-light); box-shadow: var(--card-shadow);
        }
        .chart-title { font-size: 16px; font-weight: 700; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .chart-container { position: relative; height: 300px; }

        /* TABLE */
        .table-card {
            background: white; border-radius: 16px; border: 1px solid var(--border-light);
            box-shadow: var(--card-shadow); overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8fafc; padding: 16px; text-align: left; font-size: 12px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; border-bottom: 1px solid var(--border-light); }
        td { padding: 16px; font-size: 14px; border-bottom: 1px solid var(--border-light); color: var(--text-dark); }
        tr:last-child td { border-bottom: none; }
        
        .badge-custom { padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .bg-en-cours { background: #e0e7ff; color: #4338ca; }
        .bg-termine { background: #dcfce7; color: #15803d; }
        .bg-attente { background: #fef3c7; color: #b45309; }

        .btn-logout { background: #fee2e2; color: #b91c1c; border: none; padding: 8px 16px; border-radius: 8px; font-weight: 600; font-size: 13px; }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-logo">📁 Project Manager</div>
    <nav class="nav-menu">
        <a href="DASHBOARD.jsp" class="nav-item">🏠 Accueil</a>
        <a href="tableauDeBord.jsp" class="nav-item active">📊 Dashboard</a>
        <a href="ProjetServlet" class="nav-item">📁 Mes Projets</a>
        <a href="EquipeServlet" class="nav-item">👥 Équipes</a>
        <a href="profile.jsp" class="nav-item">👤 Mon Profil</a>
    </nav>
</div>

<!-- MAIN CONTENT -->
<div class="main-content">
    <div class="page-header">
        <h1 class="page-title">Tableau de Bord</h1>
        <form action="LogoutServlet" method="post">
            <button type="submit" class="btn-logout">Déconnexion</button>
        </form>
    </div>

    <!-- KPI CARDS -->
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-label">Projets Totaux</div>
            <div class="kpi-value"><%= totalProjets %></div>
            <div class="kpi-sub">Inscrits en base</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-label">En Cours</div>
            <div class="kpi-value"><%= projetEnCours %></div>
            <div class="progress"><div class="progress-bar" style="width: <%= percentEnCours %>%"></div></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-label">Complétion Tâches</div>
            <div class="kpi-value"><%= String.format("%.0f", tauxCompletionTaches) %>%</div>
            <div class="progress"><div class="progress-bar" style="width: <%= tauxCompletionTaches %>%; background-color: #10b981;"></div></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-label">Moy. Tâches / Projet</div>
            <div class="kpi-value"><%= String.format("%.1f", moyTachesParProjet) %></div>
            <div class="kpi-sub">Charge de travail</div>
        </div>
    </div>

    <!-- CHARTS -->
    <div class="charts-grid">
        <div class="chart-card">
            <div class="chart-title">📈 État des Projets</div>
            <div class="chart-container"><canvas id="pieChart"></canvas></div>
        </div>
        <div class="chart-card">
            <div class="chart-title">📊 Performance Globale (%)</div>
            <div class="chart-container"><canvas id="barChart"></canvas></div>
        </div>
    </div>

    <!-- TABLE -->
    <div class="page-header" style="margin-top: 20px;">
        <h2 class="page-title" style="font-size: 20px;">Détails des Projets</h2>
    </div>
    <div class="table-card">
        <% if (projets != null && !projets.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom du Projet</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                <% for (Projet p : projets) { 
                    String badge = "bg-en-cours";
                    if("TERMINE".equals(p.getStatut())) badge = "bg-termine";
                    else if("EN_ATTENTE".equals(p.getStatut())) badge = "bg-attente";
                %>
                <tr>
                    <td>#<%= p.getId() %></td>
                    <td style="font-weight: 600;"><%= p.getNom() %></td>
                    <td><span class="badge-custom <%= badge %>"><%= p.getStatut() %></span></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
            <div style="padding: 40px; text-align: center; color: var(--text-secondary);">Aucun projet trouvé.</div>
        <% } %>
    </div>
</div>

<script>
    // Configuration commune des graphiques
    Chart.defaults.font.family = "'Inter', sans-serif";
    Chart.defaults.color = '#64748b';

    // PIE CHART
    new Chart(document.getElementById('pieChart'), {
        type: 'doughnut',
        data: {
            labels: ['En Cours', 'Terminé'],
            datasets: [{
                data: [<%= projetEnCours %>, <%= projetTermine %>],
                backgroundColor: ['#4f46e5', '#10b981'],
                hoverOffset: 10,
                borderWidth: 0
            }]
        },
        options: {
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } }
        }
    });

    // BAR CHART
    new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: ['Projets Terminé', 'Tâches Terminé', 'Restant'],
            datasets: [{
                label: 'Progression %',
                data: [<%= percentTermine %>, <%= tauxCompletionTaches %>, <%= tauxTachesRestantes %>],
                backgroundColor: ['#6366f1', '#10b981', '#f59e0b'],
                borderRadius: 8
            }]
        },
        options: {
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true, max: 100, grid: { display: false } },
                x: { grid: { display: false } }
            }
        }
    });
</script>

</body>
</html>