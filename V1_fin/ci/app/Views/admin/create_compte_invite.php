<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">Créer un compte invité</h1>

    <!-- Messages Flash -->
    <?php if (session()->getFlashdata('success')): ?>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <?= session()->getFlashdata('success') ?>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    <?php endif; ?>

    <?php if (session()->getFlashdata('error')): ?>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <?= session()->getFlashdata('error') ?>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    <?php endif; ?>

    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-primary text-white">
                    <h6 class="m-0 font-weight-bold"><i class="fas fa-user-plus"></i> Création rapide d'un compte invité</h6>
                </div>
                <div class="card-body">
                    <form method="post" action="<?= site_url('admin/create_compte_invite'); ?>">
                        <?= csrf_field() ?>
                        
                        <div class="text-center mb-4">
                            <i class="fas fa-user-circle fa-5x text-primary"></i>
                        </div>

                        <div class="form-group">
                            <label for="pseudo"><strong>Pseudo *</strong></label>
                            <input type="text" 
                                   class="form-control form-control-lg <?= validation_show_error('pseudo') ? 'is-invalid' : '' ?>" 
                                   id="pseudo" 
                                   name="pseudo" 
                                   value="<?= old('pseudo') ?>" 
                                   placeholder="Entrez le pseudo de l'invité">
                            <?php if (validation_show_error('pseudo')): ?>
                                <div class="invalid-feedback">
                                    <?= validation_show_error('pseudo') ?>
                                </div>
                            <?php endif; ?>
                        </div>

                        <div class="form-group">
                            <label for="mdp"><strong>Mot de passe *</strong></label>
                            <input type="password" 
                                   class="form-control form-control-lg <?= validation_show_error('mdp') ? 'is-invalid' : '' ?>" 
                                   id="mdp" 
                                   name="mdp" 
                                   placeholder="Entrez le mot de passe">
                            <?php if (validation_show_error('mdp')): ?>
                                <div class="invalid-feedback">
                                    <?= validation_show_error('mdp') ?>
                                </div>
                            <?php endif; ?>
                            <small class="form-text text-muted">Le mot de passe doit contenir au moins 8 caractères.</small>
                        </div>

                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> <strong>Information :</strong>
                            <ul class="mb-0 mt-2">
                                <li>Le compte sera créé avec le rôle <strong>"invité"</strong></li>
                                <li>L'état du compte sera <strong>"Actif"</strong></li>
                                <li>Aucun profil ne sera créé (compte simple)</li>
                            </ul>
                        </div>

                        <hr>

                        <div class="form-group text-center">
                            <button type="submit" class="btn btn-primary btn-lg btn-block">
                                <i class="fas fa-save"></i> Créer le compte invité
                            </button>
                            <a href="<?= base_url('index.php/admin/lister_membre') ?>" class="btn btn-secondary btn-lg btn-block mt-2">
                                <i class="fas fa-times"></i> Annuler
                            </a>
                        </div>

                    </form>
                </div>
            </div>

            <div class="card shadow mb-4 border-left-warning">
                <div class="card-body">
                    <div class="text-warning">
                        <i class="fas fa-exclamation-triangle fa-2x float-left mr-3"></i>
                        <strong>Important :</strong> Assurez-vous de communiquer le mot de passe à l'invité de manière sécurisée !
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Fin container-fluid -->

</div>
<!-- Fin Main Content -->
