<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.User" %>

<%
    // Sécurité de session
    User userSession = (User) session.getAttribute("user");
    if (userSession == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Récupération des KPIs
    int totalUsers = request.getAttribute("totalUsers") != null ? (int) request.getAttribute("totalUsers") : 0;
    int totalProjets = request.getAttribute("totalProjets") != null ? (int) request.getAttribute("totalProjets") : 0;
    int totalTaches = request.getAttribute("totalTaches") != null ? (int) request.getAttribute("totalTaches") : 0;
    int tauxCompletion = request.getAttribute("tauxCompletion") != null ? (int) request.getAttribute("tauxCompletion") : 0;
    int tachesTerminees = request.getAttribute("tachesTerminees") != null ? (int) request.getAttribute("tachesTerminees") : 0;
    int tachesEnCours = request.getAttribute("tachesEnCours") != null ? (int) request.getAttribute("tachesEnCours") : 0;
    int equipesActives = request.getAttribute("equipesActives") != null ? (int) request.getAttribute("equipesActives") : 0;
    Object chargeMoy = request.getAttribute("serveurSante"); 
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | ACADEMIC PM</title>
    
    <!-- Polices et Icones -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --sidebar: #1e293b;
            --sidebar-hover: #334155;
            --primary: #6366f1;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --radius: 12px;
        }

        * { box-sizing: border-box; }

        body { 
            font-family: 'Inter', sans-serif; 
            margin: 0; 
            display: flex; 
            background: var(--bg); 
            color: var(--text-main);
            -webkit-font-smoothing: antialiased;
        }

        /* Sidebar */
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
            color: white;
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

        /* Content */
        .main-content { 
            margin-left: 260px; 
            padding: 40px; 
            width: calc(100% - 260px); 
        }

        .header-title { 
            margin-bottom: 35px; 
        }
        
        .header-title h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0;
            color: var(--text-main);
        }

        /* KPI Grid */
        .kpi-grid { 
            display: grid; 
            grid-template-columns: repeat(4, 1fr); 
            gap: 20px; 
            margin-bottom: 24px; 
        }

        .kpi-card { 
            background: var(--card-bg); 
            padding: 24px; 
            border-radius: var(--radius); 
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }

        .kpi-card:hover { transform: translateY(-3px); }

        .kpi-card h3 { 
            margin: 0; 
            font-size: 0.75rem; 
            color: var(--text-muted); 
            text-transform: uppercase; 
            font-weight: 700;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .kpi-card .num { 
            font-size: 1.8rem; 
            font-weight: 800; 
            display: block; 
            margin-top: 12px; 
        }

        /* Charts */
        .chart-grid { 
            display: grid; 
            grid-template-columns: repeat(2, 1fr); 
            gap: 24px; 
        }

        .chart-container { 
            background: var(--card-bg); 
            padding: 24px; 
            border-radius: var(--radius); 
            border: 1px solid #e2e8f0;
            min-height: 350px;
        }

        .chart-title { 
            font-weight: 700; 
            margin-bottom: 20px; 
            color: var(--text-main); 
            font-size: 1rem; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }

        canvas { width: 100% !important; max-height: 260px; }

        @media (max-width: 1200px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
            .chart-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-layer-group"></i> Project Manager
        </div>
        <ul class="sidebar-menu">
            <li><a href="<%= request.getContextPath() %>/admin/dashboard" class="active"><i class="fas fa-chart-line"></i> Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/UserServlet?action=list"><i class="fas fa-user-friends"></i> Utilisateurs</a></li>
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
        <div class="header-title">
            <h2>Vue d'ensemble</h2>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card">
                <h3 style="color: var(--primary)"><i class="fas fa-users"></i> Membres</h3>
                <span class="num"><%= totalUsers %></span>
            </div>
            <div class="kpi-card">
                <h3 style="color: var(--success)"><i class="fas fa-project-diagram"></i> Projets</h3>
                <span class="num"><%= totalProjets %></span>
            </div>
            <div class="kpi-card">
                <h3 style="color: var(--warning)"><i class="fas fa-tasks"></i> Complétion</h3>
                <span class="num"><%= tauxCompletion %>%</span>
            </div>
            <div class="kpi-card">
                <h3 style="color: var(--primary)"><i class="fas fa-spinner"></i> En Cours</h3>
                <span class="num"><%= tachesEnCours %></span>
            </div>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card">
                <h3 style="color: #1abc9c;"><i class="fas fa-check-circle"></i> Tâches Finies</h3>
                <span class="num"><%= tachesTerminees %></span>
            </div>
            <div class="kpi-card">
                <h3 style="color: #9b59b6;"><i class="fas fa-user-group"></i> Équipes</h3>
                <span class="num"><%= equipesActives %></span>
            </div>
            <div class="kpi-card">
                <h3 style="color: var(--sidebar);"><i class="fas fa-list-ul"></i> Total Tâches</h3>
                <span class="num"><%= totalTaches %></span>
            </div>
            <div class="kpi-card">
                <h3 style="color: #e67e22;"><i class="fas fa-balance-scale"></i> Charge Moy.</h3>
                <span class="num"><%= chargeMoy %> <small style="font-size: 0.5em; color: var(--text-muted)">tâches/prj</small></span>
            </div>
        </div>

        <div class="chart-grid">
            <div class="chart-container">
                <div class="chart-title"><i class="fas fa-chart-pie" style="color:var(--primary)"></i> Statut des Projets</div>
                <canvas id="chartProjets"></canvas>
            </div>
            
            <div class="chart-container">
                <div class="chart-title"><i class="fas fa-fire" style="color:var(--danger)"></i> Priorités des Tâches</div>
                <canvas id="chartPriorites"></canvas>
            </div>

            <div class="chart-container">
                <div class="chart-title"><i class="fas fa-user-edit" style="color:var(--success)"></i> Charge par Membre (Top 5)</div>
                <canvas id="chartMembres"></canvas>
            </div>

            <div class="chart-container">
                <div class="chart-title"><i class="fas fa-stream" style="color:var(--warning)"></i> État d'Avancement</div>
                <canvas id="chartTachesStatut"></canvas>
            </div>
        </div>
    </main>

    <%! 
        public String mapToLabels(Map<String, Integer> m) {
            if(m == null || m.isEmpty()) return "'Aucune donnée'";
            StringJoiner sj = new StringJoiner(",");
            for(String s : m.keySet()) sj.add("'" + s + "'");
            return sj.toString();
        }
        public String mapToValues(Map<String, Integer> m) {
            if(m == null || m.isEmpty()) return "0";
            StringJoiner sj = new StringJoiner(",");
            for(Integer i : m.values()) sj.add(i.toString());
            return sj.toString();
        }
    %>

    <script>
        const chartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { 
                legend: { 
                    position: 'bottom', 
                    labels: { 
                        padding: 20,
                        usePointStyle: true,
                        font: { size: 11, family: 'Inter' } 
                    } 
                } 
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            // Statut Projets
            new Chart(document.getElementById('chartProjets'), {
                type: 'doughnut',
                data: {
                    labels: [<%= mapToLabels((Map)request.getAttribute("statsProjets")) %>],
                    datasets: [{
                        data: [<%= mapToValues((Map)request.getAttribute("statsProjets")) %>],
                        backgroundColor: ['#6366f1', '#10b981', '#f59e0b', '#ef4444'],
                        borderWidth: 0,
                        hoverOffset: 10
                    }]
                },
                options: { ...chartOptions, cutout: '70%' }
            });

            // Priorités
            new Chart(document.getElementById('chartPriorites'), {
                type: 'polarArea',
                data: {
                    labels: [<%= mapToLabels((Map)request.getAttribute("statsPriorites")) %>],
                    datasets: [{
                        data: [<%= mapToValues((Map)request.getAttribute("statsPriorites")) %>],
                        backgroundColor: ['rgba(239, 68, 68, 0.7)', 'rgba(245, 158, 11, 0.7)', 'rgba(16, 185, 129, 0.7)']
                    }]
                },
                options: chartOptions
            });

            // Charge Membres
            new Chart(document.getElementById('chartMembres'), {
                type: 'bar',
                data: {
                    labels: [<%= mapToLabels((Map)request.getAttribute("chargeTravail")) %>],
                    datasets: [{
                        label: 'Tâches assignées',
                        data: [<%= mapToValues((Map)request.getAttribute("chargeTravail")) %>],
                        backgroundColor: '#6366f1',
                        borderRadius: 6
                    }]
                },
                options: { ...chartOptions, indexAxis: 'y', scales: { x: { grid: { display: false } }, y: { grid: { display: false } } } }
            });

            // Statut Tâches
            new Chart(document.getElementById('chartTachesStatut'), {
                type: 'pie',
                data: {
                    labels: [<%= mapToLabels((Map)request.getAttribute("statsTachesStatut")) %>],
                    datasets: [{
                        data: [<%= mapToValues((Map)request.getAttribute("statsTachesStatut")) %>],
                        backgroundColor: ['#94a3b8', '#3498db', '#10b981'],
                        borderWidth: 0
                    }]
                },
                options: chartOptions
            });
        });
    </script>
</body>
</html>