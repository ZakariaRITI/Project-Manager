<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Project Manager</title>
    
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

        /* ========== HEADER TOP ========== */
        .page-header {
            text-align: center;
            padding: 5px 40px 50px;
            margin-bottom: 20px;
        }

        .header-icon {
            font-size: 48px;
            margin-bottom: 20px;
            display: block;
        }

        .header-title {
            font-size: 36px;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0 0 12px 0;
            letter-spacing: -0.5px;
        }

        .header-description {
            font-size: 16px;
            color: var(--text-secondary);
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
            font-weight: 400;
        }

        /* ========== CONTENEUR PRINCIPAL ========== */
        .register-container {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ========== CARTE D'INSCRIPTION ========== */
        .register-card {
            background: var(--bg-white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            padding: 50px 40px;
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
        }

        /* Décoration florale */
        .register-card::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, var(--accent-primary) 0%, transparent 70%);
            opacity: 0.05;
            border-radius: 50%;
            pointer-events: none;
        }

        .register-card::after {
            content: '';
            position: absolute;
            bottom: -80px;
            left: -80px;
            width: 250px;
            height: 250px;
            background: radial-gradient(circle, var(--accent-secondary) 0%, transparent 70%);
            opacity: 0.05;
            border-radius: 50%;
            pointer-events: none;
        }

        /* ========== HEADER ========== */
        .register-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
            z-index: 1;
        }

        .register-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0 0 8px 0;
            letter-spacing: -0.5px;
        }

        .register-subtitle {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0;
            font-weight: 400;
        }

        /* ========== FORMULAIRE ========== */
        .register-form {
            position: relative;
            z-index: 1;
        }

        .form-group {
            margin-bottom: 18px;
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

        /* ========== GROUPE DE CHAMPS (2 COLONNES) ========== */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 18px;
        }

        .form-row .form-group {
            margin-bottom: 0;
        }

        /* ========== BOUTON SUBMIT ========== */
        .btn-submit {
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
            margin-top: 10px;
            margin-bottom: 24px;
        }

        .btn-submit:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-submit:active {
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

        /* ========== FOOTER / LIEN ========== */
        .register-footer {
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .register-footer-text {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0 0 12px 0;
        }

        .register-footer-link {
            color: var(--accent-primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .register-footer-link:hover {
            color: #4338ca;
        }

        .register-benefits {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--border-light);
        }

        .benefit-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: var(--text-secondary);
        }

        .benefit-icon {
            color: var(--success);
            font-weight: bold;
        }

        /* ========== VALIDATION MESSAGES ========== */
        .form-text {
            font-size: 12px;
            color: var(--text-tertiary);
            margin-top: 4px;
            display: block;
        }

        .form-control.is-invalid {
            border-color: var(--error);
        }

        .form-control.is-invalid:focus {
            box-shadow: 0 0 0 3px var(--error-light);
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 768px) {
            .page-header {
                padding: 50px 30px 40px;
                margin-bottom: 20px;
            }

            .header-title {
                font-size: 28px;
            }

            .header-description {
                font-size: 14px;
            }

            .register-card {
                padding: 40px 32px;
            }

            .register-title {
                font-size: 28px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 18px;
            }
        }

        @media (max-width: 480px) {
            .page-header {
                padding: 40px 20px 32px;
                margin-bottom: 16px;
            }

            .header-icon {
                font-size: 40px;
                margin-bottom: 16px;
            }

            .header-title {
                font-size: 24px;
            }

            .header-description {
                font-size: 13px;
            }

            .register-container {
                max-width: 100%;
            }

            .register-card {
                padding: 32px 24px;
                border-radius: 14px;
            }

            .register-title {
                font-size: 24px;
            }

            .register-subtitle {
                font-size: 13px;
            }

            .form-control {
                padding: 11px 12px;
                font-size: 13px;
            }

            .btn-submit {
                padding: 12px 20px;
                font-size: 14px;
            }

            .register-header {
                margin-bottom: 32px;
            }
        }
    </style>
</head>
<body>
    <!-- Header Top avec contenu riche -->
    <div class="page-header">
        <span class="header-icon">🎯</span>
        <h1 class="header-title">Rejoignez la Communauté</h1>
        <p class="header-description">
            Rejoignez des centaines d'équipes qui transforment leur gestion de projets 
            avec Project Manager. Gagnez en productivité et en collaboration dès le premier jour.
        </p>
    </div>

    <div class="register-container">
        <div class="register-card">
            <!-- Header -->
            <div class="register-header">
                <h1 class="register-title">Créer un compte</h1>
                <p class="register-subtitle">Rejoignez Project Manager et optimisez votre gestion de projets</p>
            </div>

            <!-- Formulaire -->
            <form action="RegisterServlet" method="post" class="register-form" novalidate>
                
                <!-- Nom & Prénom (2 colonnes) -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="nom">Nom</label>
                        <input 
                            type="text" 
                            id="nom"
                            name="nom" 
                            class="form-control" 
                            placeholder="Votre nom" 
                            required
                        >
                    </div>
                    <div class="form-group">
                        <label for="prenom">Prénom</label>
                        <input 
                            type="text" 
                            id="prenom"
                            name="prenom" 
                            class="form-control" 
                            placeholder="Votre prénom" 
                            required
                        >
                    </div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="email">Adresse Email</label>
                    <input 
                        type="email" 
                        id="email"
                        name="email" 
                        class="form-control" 
                        placeholder="exemple@societe.com" 
                        required
                    >
                    <small class="form-text">Nous ne partagerons jamais votre email</small>
                </div>

                <!-- Mot de passe -->
                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input 
                        type="password" 
                        id="password"
                        name="password" 
                        class="form-control" 
                        placeholder="Minimum 8 caractères" 
                        required
                    >
                    <small class="form-text">Doit contenir lettres, chiffres et caractères spéciaux</small>
                </div>

                <!-- Bouton Submit -->
                <button type="submit" class="btn-submit">
                    S'inscrire Maintenant
                </button>

                <!-- Divider -->
                <div class="form-divider">
                    <span>OU</span>
                </div>

                <!-- Footer -->
                <div class="register-footer">
                    <p class="register-footer-text">
                        Vous avez déjà un compte ?
                        <a href="login.jsp" class="register-footer-link">Se connecter</a>
                    </p>

                    <!-- Avantages -->
                    <div class="register-benefits">
                        <div class="benefit-item">
                            <span class="benefit-icon">✓</span>
                            <span>Interface intuitive et facile à maîtriser</span>
                        </div>
                        <div class="benefit-item">
                            <span class="benefit-icon">✓</span>
                            <span>Synchronisation en temps réel de vos projets</span>
                        </div>
                        <div class="benefit-item">
                            <span class="benefit-icon">✓</span>
                            <span>Outils collaboratifs pour votre équipe</span>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
