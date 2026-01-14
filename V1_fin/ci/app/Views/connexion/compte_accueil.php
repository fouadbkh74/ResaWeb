<!-- Page d'accueil pour les invités -->
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0">
                        <i class="fas fa-user-check"></i> Bienvenue, <?= esc($user ?? 'Invité') ?> !
                    </h4>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> 
                        <strong>Compte Invité</strong>
                        <p class="mb-0">Vous êtes connecté en tant qu'invité. Votre accès est limité.</p>
                    </div>

                    <div class="text-center my-4">
                        <i class="fas fa-user-circle fa-5x text-success"></i>
                    </div>

                    <div class="card mb-3">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-id-badge"></i> Informations de votre compte
                            </h5>
                            <hr>
                            <p><strong>Pseudo :</strong> <?= esc($user ?? 'Invité') ?></p>
                             </div>
                    </div>

                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i> 
                        <strong>Accès limité</strong>
                        <p class="mb-0">En tant qu'invité, vous n'avez pas accès aux fonctionnalités avancées du site. Pour obtenir un accès complet, veuillez contacter l'administrateur.</p>
                    </div>

                    <div class="text-center mt-4">
                        <a href="<?= base_url('index.php/compte/deconnecter') ?>" class="btn btn-danger btn-lg">
                            <i class="fas fa-sign-out-alt"></i> Se déconnecter
                        </a>
                    </div>
                </div>
                <div class="card-footer text-muted text-center">
                    <small>Connecté en tant qu'invité</small>
                </div>
            </div>
        </div>
    </div>
</div>
<br><br><br>