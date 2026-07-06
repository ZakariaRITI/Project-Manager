<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Project Manager</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Typographie - Inter -->
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
            --border-focus: #cbd5e1;
            --accent-primary: #4f46e5;      /* Indigo Pro */
            --accent-secondary: #10b981;     /* Émeraude */
            --accent-light: #eef2ff;        /* Indigo très clair */
            --success: #10b981;
            --error: #ef4444;
            --error-light: #fee2e2;
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
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            color: var(--text-dark);
            padding: 20px;
        }

        /* ========== PAGE WRAPPER ========== */
        .page-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 100vh;
            gap: 0;
        }

        /* ========== SECTION CONTENU (GAUCHE) ========== */
        .content-section {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--bg-light);
            position: relative;
            overflow: hidden;
        }

        .content-inner {
            max-width: 500px;
        }

        .content-title {
            font-size: 48px;
            font-weight: 700;
            line-height: 1.2;
            color: var(--text-dark);
            margin-bottom: 16px;
            letter-spacing: -0.5px;
        }

        .content-description {
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 40px;
            font-weight: 400;
            line-height: 1.6;
        }

        /* Steps List */
        .steps-list {
            display: flex;
            flex-direction: column;
            gap: 24px;
            margin-bottom: 50px;
        }

        .step-item {
            display: flex;
            gap: 16px;
            align-items: flex-start;
        }

        .step-number {
            font-size: 20px;
            font-weight: 700;
            color: white;
            background: var(--accent-primary);
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .step-text h3 {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 0 6px 0;
        }

        .step-text p {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0;
            line-height: 1.5;
        }

        /* Features Mini */
        .features-mini {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            padding-top: 40px;
            border-top: 1px solid var(--border-light);
        }

        .feature-mini-item {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .feature-mini-icon {
            font-size: 32px;
        }

        .feature-mini-text {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .feature-mini-desc {
            font-size: 12px;
            color: var(--text-secondary);
        }

        /* ========== SECTION LOGIN (DROITE) ========== */
        .login-section {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            background: var(--bg-white);
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            position: relative;
            z-index: 2;
        }

        /* Logo Petit */
        .login-logo {
            margin-bottom: 32px;
            display: flex;
            justify-content: center;
        }

        .logo-mini {
            width: 60px;
            height: 60px;
            filter: drop-shadow(0 2px 8px rgba(79, 70, 229, 0.1));
        }

        /* Titre */
        .login-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0 0 8px 0;
            text-align: center;
            letter-spacing: -0.5px;
        }

        .login-subtitle {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0 0 32px 0;
            text-align: center;
            font-weight: 400;
        }

        /* ========== ERROR MESSAGE ========== */
        .alert-error {
            background: var(--error-light);
            border: 1.5px solid var(--error);
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 24px;
            display: none;
            color: var(--error);
            font-size: 14px;
            font-weight: 500;
        }

        .alert-error.show {
            display: block;
        }

        .alert-error-icon {
            display: inline-block;
            margin-right: 8px;
            font-weight: bold;
        }

        /* ========== FORMULAIRE ========== */
        .login-form {
            position: relative;
            z-index: 1;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        /* ========== INPUTS ========== */
        .form-control {
            width: 100%;
            padding: 12px 14px;
            font-size: 14px;
            border: 1.5px solid var(--border-light);
            border-radius: 10px;
            background: var(--bg-white);
            color: var(--text-dark);
            transition: all 0.2s ease;
            box-shadow: none;
            font-weight: 400;
        }

        .form-control::placeholder {
            color: var(--text-tertiary);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px var(--accent-light);
            background: var(--bg-white);
            color: var(--text-dark);
        }

        .form-control:hover:not(:focus) {
            border-color: var(--border-focus);
        }

        /* ========== REMEMBER & FORGOT ========== */
        .form-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            gap: 12px;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }

        .form-check input {
            width: 18px;
            height: 18px;
            accent-color: var(--accent-primary);
            cursor: pointer;
        }

        .form-check label {
            font-size: 13px;
            color: var(--text-secondary);
            cursor: pointer;
            margin: 0;
            text-transform: none;
            letter-spacing: normal;
            font-weight: 400;
        }

        .forgot-link {
            color: var(--accent-primary);
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .forgot-link:hover {
            color: #4338ca;
        }

        /* ========== BOUTON LOGIN ========== */
        .btn-login {
            width: 100%;
            padding: 14px 24px;
            font-size: 15px;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            background: var(--accent-primary);
            color: white;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: var(--shadow-sm);
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 24px;
        }

        .btn-login:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-login:active {
            transform: translateY(0);
            box-shadow: var(--shadow-sm);
        }

        /* ========== DIVIDER ========== */
        .form-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 24px 0;
            color: var(--text-tertiary);
        }

        .form-divider::before,
        .form-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border-light);
        }

        .form-divider span {
            font-size: 12px;
            font-weight: 500;
            white-space: nowrap;
        }

        /* ========== FOOTER / INSCRIPTION ========== */
        .login-footer {
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .login-footer-text {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0;
        }

        .login-footer-link {
            color: var(--accent-primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .login-footer-link:hover {
            color: #4338ca;
        }

        .info-section {
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid var(--border-light);
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }

        .info-icon {
            color: var(--accent-primary);
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

            .content-section {
                padding: 50px 40px;
                min-height: auto;
            }

            .login-section {
                padding: 50px 40px;
                min-height: auto;
            }

            .content-title {
                font-size: 40px;
            }

            .features-mini {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .content-section {
                padding: 40px 24px;
            }

            .login-section {
                padding: 40px 24px;
            }

            .content-title {
                font-size: 32px;
            }

            .login-title {
                font-size: 28px;
            }

            .login-card {
                max-width: 100%;
            }

            .logo-mini {
                width: 50px;
                height: 50px;
            }

            .steps-list {
                gap: 20px;
            }

            .features-mini {
                grid-template-columns: 1fr;
                gap: 16px;
            }
        }

        @media (max-width: 640px) {
            .content-section {
                padding: 32px 20px;
            }

            .login-section {
                padding: 32px 20px;
            }

            .content-title {
                font-size: 28px;
            }

            .login-title {
                font-size: 24px;
            }

            .content-description {
                font-size: 16px;
            }

            .login-subtitle {
                font-size: 13px;
            }

            .logo-mini {
                width: 45px;
                height: 45px;
            }

            .step-item {
                gap: 12px;
            }

            .step-number {
                width: 40px;
                height: 40px;
                font-size: 18px;
            }

            .form-control {
                padding: 11px 12px;
                font-size: 13px;
            }

            .btn-login {
                padding: 12px 20px;
                font-size: 14px;
            }

            .form-controls {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <!-- Section Contenu (Gauche) -->
        <div class="content-section">
            <div class="content-inner">
                <h2 class="content-title">Bienvenue de Retour</h2>
                <p class="content-description">
                    Accédez à votre espace de travail et continuez à gérer vos projets.
                </p>

                <!-- Steps -->
                <div class="steps-list">
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-text">
                            <h3>Connectez-vous rapidement</h3>
                            <p>Entrez vos identifiants en quelques secondes</p>
                        </div>
                    </div>

                    <div class="step-item">
                        <div class="step-number">2</div>
                        <div class="step-text">
                            <h3>Accédez à votre tableau de bord</h3>
                            <p>Visualisez tous vos projets et tâches en un coup d'œil</p>
                        </div>
                    </div>

                    <div class="step-item">
                        <div class="step-number">3</div>
                        <div class="step-text">
                            <h3>Collaborez avec votre équipe</h3>
                            <p>Partagez, commentez et suivez la progression en temps réel</p>
                        </div>
                    </div>
                </div>

                <!-- Features Mini -->
                <div class="features-mini">
                    <div class="feature-mini-item">
                        <span class="feature-mini-icon">⚡</span>
                        <span class="feature-mini-text">Performance</span>
                        <span class="feature-mini-desc">Accès ultra-rapide à vos données</span>
                    </div>
                    <div class="feature-mini-item">
                        <span class="feature-mini-icon">🔒</span>
                        <span class="feature-mini-text">Sécurité</span>
                        <span class="feature-mini-desc">Vos données sont protégées</span>
                    </div>
                    <div class="feature-mini-item">
                        <span class="feature-mini-icon">📱</span>
                        <span class="feature-mini-text">Multiplateforme</span>
                        <span class="feature-mini-desc">Accès depuis n'importe où</span>
                    </div>
                    <div class="feature-mini-item">
                        <span class="feature-mini-icon">🤝</span>
                        <span class="feature-mini-text">Collaboration</span>
                        <span class="feature-mini-desc">Travail d'équipe facilité</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Section Login (Droite) -->
        <div class="login-section">
            <div class="login-card">
                <!-- Logo -->
                <div class="login-logo">
                    <svg class="logo-mini" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="30" cy="30" r="28" fill="var(--accent-primary)" opacity="0.1" stroke="var(--accent-primary)" stroke-width="1.5"/>
                        <g fill="var(--accent-primary)">
                            <rect x="12" y="15" width="10" height="10" rx="2"/>
                            <rect x="25" y="15" width="10" height="10" rx="2" opacity="0.7"/>
                            <rect x="38" y="15" width="10" height="10" rx="2" opacity="0.4"/>
                            <rect x="12" y="28" width="10" height="10" rx="2" opacity="0.7"/>
                            <rect x="25" y="28" width="10" height="10" rx="2"/>
                            <rect x="18" y="41" width="10" height="10" rx="2" opacity="0.6"/>
                        </g>
                        <g stroke="var(--accent-primary)" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M 38 38 L 42 42 L 48 36" opacity="0.8"/>
                        </g>
                    </svg>
                </div>

                <!-- Titre -->
                <h1 class="login-title">Se connecter</h1>
                <p class="login-subtitle">Accédez à votre espace Project Manager</p>

                <!-- Message d'erreur -->
                <% 
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                    <div class="alert-error show">
                        <span class="alert-error-icon">⚠</span>
                        <%= error %>
                    </div>
                <%
                    }
                %>

                <!-- Formulaire -->
                <form action="LoginServlet" method="post" class="login-form" novalidate>
                    <!-- Email -->
                    <div class="form-group">
                        <label for="email">Adresse Email</label>
                        <input 
                            type="email" 
                            id="email"
                            name="email" 
                            class="form-control" 
                            placeholder="vous@exemple.com" 
                            required
                        >
                    </div>

                    <!-- Mot de passe -->
                    <div class="form-group">
                        <label for="password">Mot de passe</label>
                        <input 
                            type="password" 
                            id="password"
                            name="password" 
                            class="form-control" 
                            placeholder="••••••••" 
                            required
                        >
                    </div>

                    <!-- Remember & Forgot -->
                    <div class="form-controls">
                        <div class="form-check">
                            <input type="checkbox" id="remember" name="remember" value="on" class="form-check-input">
                            <label for="remember" class="form-check-label">
                                Me souvenir de moi
                            </label>
                        </div>
                        <a href="#" class="forgot-link">Mot de passe oublié ?</a>
                    </div>

                    <!-- Bouton Login -->
                    <button type="submit" class="btn-login">
                        Se Connecter
                    </button>
                </form>

                <!-- Divider -->
                <div class="form-divider">
                    <span>OU</span>
                </div>

                <!-- Footer -->
                <div class="login-footer">
                    <p class="login-footer-text">
                        Vous n'avez pas de compte ?
                        <a href="register.jsp" class="login-footer-link">S'inscrire maintenant</a>
                    </p>

                    <!-- Info Supplémentaire -->
                    <div class="info-section">
                        <div class="info-item">
                            <span class="info-icon">✓</span>
                            <span>Connexion sécurisée et chiffrée</span>
                        </div>
                        <div class="info-item">
                            <span class="info-icon">✓</span>
                            <span>Authentification multi-facteurs disponible</span>
                        </div>
                        <div class="info-item">
                            <span class="info-icon">✓</span>
                            <span>Vos données sont toujours protégées</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Décoration -->
            <div class="decoration decoration-top"></div>
            <div class="decoration decoration-bottom"></div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
