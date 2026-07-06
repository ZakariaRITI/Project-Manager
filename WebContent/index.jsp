<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion de Projets</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Typographie - Inter (sans-serif minimaliste) -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }

        /* ========== COULEURS PALETTE ========== */
        :root {
            --bg-light: #f8f9fa;
            --bg-white: #ffffff;
            --text-dark: #1a202c;
            --text-secondary: #64748b;
            --text-tertiary: #94a3b8;
            --border-light: #e2e8f0;
            --accent-primary: #4f46e5;      /* Indigo Pro */
            --accent-secondary: #10b981;     /* Émeraude */
            --accent-light: #eef2ff;        /* Indigo très clair */
            --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
            --shadow-lg: 0 10px 25px rgba(0,0,0,0.08);
        }

        /* ========== RESET ========== */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        body {
            background: linear-gradient(135deg, var(--bg-light) 0%, #f1f5f9 100%);
            color: var(--text-dark);
        }

        /* ========== PAGE WRAPPER ========== */
        .page-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 100vh;
            gap: 0;
        }

        /* ========== SECTION FEATURES (GAUCHE) ========== */
        .features-section {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--bg-light);
            position: relative;
            overflow: hidden;
        }

        .features-content {
            max-width: 500px;
        }

        .features-title {
            font-size: 48px;
            font-weight: 700;
            line-height: 1.2;
            color: var(--text-dark);
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .features-subtitle {
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 40px;
            font-weight: 400;
        }

        /* Features List */
        .features-list {
            display: flex;
            flex-direction: column;
            gap: 24px;
            margin-bottom: 50px;
        }

        .feature-item {
            display: flex;
            gap: 16px;
            align-items: flex-start;
        }

        .feature-icon {
            font-size: 32px;
            flex-shrink: 0;
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .feature-text h3 {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 0 6px 0;
        }

        .feature-text p {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0;
            line-height: 1.5;
        }

        /* Stats Section */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            padding-top: 40px;
            border-top: 1px solid var(--border-light);
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .stat-number {
            font-size: 24px;
            font-weight: 700;
            color: var(--accent-primary);
        }

        .stat-label {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 500;
        }

        /* ========== SECTION AUTH (DROITE) ========== */
        .auth-section {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            background: var(--bg-white);
        }

        .auth-card {
            width: 100%;
            max-width: 420px;
            text-align: center;
            position: relative;
            z-index: 2;
        }

        /* Logo */
        .logo-container {
            margin-bottom: 32px;
            display: flex;
            justify-content: center;
        }

        .logo-svg {
            width: 80px;
            height: 80px;
            filter: drop-shadow(0 4px 12px rgba(79, 70, 229, 0.15));
        }

        /* Titre Auth */
        .auth-title {
            font-size: 36px;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0 0 8px 0;
            letter-spacing: -0.5px;
        }

        .auth-subtitle {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0 0 24px 0;
            font-weight: 400;
        }

        /* Description */
        .auth-description {
            margin-bottom: 32px;
        }

        .auth-description p {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.6;
            margin: 0;
        }

        /* ========== CONTENEUR BOUTONS ========== */
        .btn-group-hero {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 24px;
        }

        /* ========== BOUTONS PERSONNALISÉS ========== */
        .btn-hero {
            padding: 14px 32px;
            font-size: 15px;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            line-height: 1.5;
            box-shadow: var(--shadow-sm);
        }

        .btn-hero:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-hero:active {
            transform: translateY(0);
            box-shadow: var(--shadow-sm);
        }

        /* BOUTON PRINCIPAL - Login (Indigo) */
        .btn-login {
            background: var(--accent-primary);
            color: white;
        }

        .btn-login:hover {
            background: #4338ca;
            color: white;
            text-decoration: none;
        }

        /* BOUTON SECONDAIRE - Register (Outline) */
        .btn-register {
            background: transparent;
            color: var(--accent-primary);
            border: 2px solid var(--accent-primary);
        }

        .btn-register:hover {
            background: var(--accent-light);
            color: var(--accent-primary);
            text-decoration: none;
        }

        /* Footer Auth */
        .auth-footer {
            padding-top: 24px;
            border-top: 1px solid var(--border-light);
        }

        .footer-text {
            font-size: 13px;
            color: var(--text-secondary);
            margin: 0 0 8px 0;
        }

        .footer-link {
            color: var(--accent-primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .footer-link:hover {
            color: #4338ca;
        }

        .footer-note {
            font-size: 12px;
            color: var(--text-tertiary);
            margin: 0;
        }

        /* ========== DÉCORATIONS ========== */
        .decoration {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
            pointer-events: none;
        }

        .decoration-top {
            width: 400px;
            height: 400px;
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
            top: -150px;
            right: -100px;
        }

        .decoration-bottom {
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, var(--accent-secondary), var(--accent-primary));
            bottom: -100px;
            left: -80px;
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 1024px) {
            .page-wrapper {
                grid-template-columns: 1fr;
            }

            .features-section {
                padding: 50px 40px;
                min-height: auto;
            }

            .auth-section {
                padding: 50px 40px;
                min-height: auto;
            }

            .features-title {
                font-size: 40px;
            }

            .auth-title {
                font-size: 32px;
            }

            .stats-section {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .features-section {
                padding: 40px 24px;
            }

            .auth-section {
                padding: 40px 24px;
            }

            .features-title {
                font-size: 32px;
            }

            .auth-title {
                font-size: 28px;
            }

            .auth-card {
                max-width: 100%;
            }

            .logo-svg {
                width: 70px;
                height: 70px;
            }

            .features-list {
                gap: 20px;
            }

            .stats-section {
                grid-template-columns: repeat(3, 1fr);
                gap: 16px;
            }

            .stat-number {
                font-size: 20px;
            }

            .stat-label {
                font-size: 12px;
            }
        }

        @media (max-width: 640px) {
            .features-section {
                padding: 32px 20px;
            }

            .auth-section {
                padding: 32px 20px;
            }

            .features-title {
                font-size: 28px;
            }

            .auth-title {
                font-size: 24px;
            }

            .features-subtitle {
                font-size: 16px;
            }

            .auth-subtitle {
                font-size: 13px;
            }

            .logo-svg {
                width: 60px;
                height: 60px;
            }

            .feature-item {
                gap: 12px;
            }

            .feature-icon {
                font-size: 28px;
                width: 40px;
                height: 40px;
            }

            .stats-section {
                grid-template-columns: 1fr;
                gap: 12px;
                padding-top: 24px;
            }

            .btn-hero {
                padding: 12px 24px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <!-- Conteneur Full Page -->
    <div class="page-wrapper">
        <!-- Section Gauche - Features -->
        <div class="features-section">
            <div class="features-content">
                <h2 class="features-title">Simplicité & Efficacité</h2>
                <p class="features-subtitle">Transformez votre gestion de projets</p>

                <div class="features-list">
                    <div class="feature-item">
                        <span class="feature-icon">📋</span>
                        <div class="feature-text">
                            <h3>Gestion Centralisée</h3>
                            <p>Tous vos projets et tâches au même endroit</p>
                        </div>
                    </div>

                    <div class="feature-item">
                        <span class="feature-icon">👥</span>
                        <div class="feature-text">
                            <h3>Collaboration d'Équipe</h3>
                            <p>Travaillez ensemble en temps réel</p>
                        </div>
                    </div>

                    <div class="feature-item">
                        <span class="feature-icon">📊</span>
                        <div class="feature-text">
                            <h3>Suivi Transparent</h3>
                            <p>Visualisez la progression de chaque projet</p>
                        </div>
                    </div>

                    <div class="feature-item">
                        <span class="feature-icon">⚡</span>
                        <div class="feature-text">
                            <h3>Automatisations</h3>
                            <p>Gagnez du temps avec des flux automatisés</p>
                        </div>
                    </div>
                </div>

                <div class="stats-section">
                    <div class="stat-item">
                        <span class="stat-number">500+</span>
                        <span class="stat-label">Entreprises</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">10K+</span>
                        <span class="stat-label">Projets Actifs</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">99.9%</span>
                        <span class="stat-label">Disponibilité</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Section Droite - Auth Form -->
        <div class="auth-section">
            <div class="auth-card">
                <!-- Logo -->
                <div class="logo-container">
                    <svg class="logo-svg" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg">
                        <!-- Cercle de fond -->
                        <circle cx="30" cy="30" r="28" fill="var(--accent-primary)" opacity="0.1" stroke="var(--accent-primary)" stroke-width="1.5"/>
                        
                        <!-- Carrés en cascade (représentant des tâches/projets) -->
                        <g fill="var(--accent-primary)">
                            <!-- Carré 1 (haut-gauche) -->
                            <rect x="12" y="15" width="10" height="10" rx="2"/>
                            <!-- Carré 2 (haut-droite) -->
                            <rect x="25" y="15" width="10" height="10" rx="2" opacity="0.7"/>
                            <!-- Carré 3 (milieu-gauche) -->
                            <rect x="38" y="15" width="10" height="10" rx="2" opacity="0.4"/>
                            
                            <!-- Carré 4 (bas-gauche) -->
                            <rect x="12" y="28" width="10" height="10" rx="2" opacity="0.7"/>
                            <!-- Carré 5 (bas-centre) -->
                            <rect x="25" y="28" width="10" height="10" rx="2"/>
                            
                            <!-- Carré 6 (très bas) -->
                            <rect x="18" y="41" width="10" height="10" rx="2" opacity="0.6"/>
                        </g>
                        
                        <!-- Checkmark (validation) -->
                        <g stroke="var(--accent-primary)" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M 38 38 L 42 42 L 48 36" opacity="0.8"/>
                        </g>
                    </svg>
                </div>

                <!-- Titre & Description -->
                <h1 class="auth-title">Project Manager</h1>
                <p class="auth-subtitle">Bienvenue dans votre nouveau système de gestion</p>

                <!-- Description détaillée -->
                <div class="auth-description">
                    <p>
                        Planifiez, organisez et collaborez efficacement. 
                        Avec une interface intuitive et des outils puissants, 
                        menez vos projets vers le succès.
                    </p>
                </div>

                <!-- Groupe de boutons -->
                <div class="btn-group-hero">
                    <!-- Bouton Login (Primaire) -->
                    <a href="login.jsp" class="btn-hero btn-login">
                        Se connecter
                    </a>

                    <!-- Bouton Register (Secondaire) -->
                    <a href="register.jsp" class="btn-hero btn-register">
                        Créer un compte
                    </a>
                </div>

                <!-- Texte additif -->
                <div class="auth-footer">
                    <p class="footer-text">
                        Pas encore inscrit ? 
                        <a href="register.jsp" class="footer-link">Créez votre compte gratuitement</a>
                    </p>
                    <p class="footer-note">
                       La plateforme collaborative pour mener vos projets à la réussite.
                    </p>
                </div>
            </div>

            <!-- Décoration florale -->
            <div class="decoration decoration-top"></div>
            <div class="decoration decoration-bottom"></div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
