<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">Mon Profil</h1>

    <!-- Messages Flash -->
    <?php if (session()->getFlashdata('success')) : ?>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <?= session()->getFlashdata('success') ?>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    <?php endif; ?>

    <?php if (session()->getFlashdata('error')) : ?>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <?= session()->getFlashdata('error') ?>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    <?php endif; ?>

    <div class="row">
        <!-- Carte Profil (Gauche) -->
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-success text-white">
                    <h6 class="m-0 font-weight-bold">Photo de profil</h6>
                </div>
                <div class="card-body text-center">
                    <img class="img-profile rounded-circle mb-3" src="<?= base_url('bootstrap2/bootstrap2/img/undraw_profile.svg'); ?>" style="width: 150px; height: 150px;">
                    <h4><?= esc($profil['cpt_pseudo']) ?></h4>
                    <p class="text-muted"><?= esc($profil['cpt_Role']) ?></p>
                    <?php if (isset($profil['cpt_etat']) && $profil['cpt_etat'] == 'A'): ?>
                        <span class="badge badge-success">Compte Actif</span>
                    <?php else: ?>
                        <span class="badge badge-danger">Compte Inactif</span>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <!-- Détails Profil (Droite) -->
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-success text-white d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold">Informations Personnelles</h6>
                    <!-- Pas de bouton modifier pour les membres -->
                </div>
                <div class="card-body">
                    <?php if (isset($profil) && !empty($profil)): ?>
                        <div class="row mb-3">
                            <div class="col-sm-3 font-weight-bold">Nom :</div>
                            <div class="col-sm-9"><?= esc($profil['pfl_Nom'] ?? 'Non renseigné') ?></div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3 font-weight-bold">Prénom :</div>
                            <div class="col-sm-9"><?= esc($profil['pfl_prenom'] ?? 'Non renseigné') ?></div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3 font-weight-bold">Email :</div>
                            <div class="col-sm-9"><?= esc($profil['pfl_email'] ?? 'Non renseigné') ?></div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3 font-weight-bold">Téléphone :</div>
                            <div class="col-sm-9"><?= esc($profil['pfl_numTel'] ?? 'Non renseigné') ?></div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3 font-weight-bold">Date de naissance :</div>
                            <div class="col-sm-9"><?= esc($profil['pfl_date_ncs'] ?? 'Non renseignée') ?></div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3 font-weight-bold">Adresse :</div>
                            <div class="col-sm-9"><?= esc($profil['pfl_adresse'] ?? 'Non renseignée') ?></div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3 font-weight-bold">Code Postal :</div>
                            <div class="col-sm-9"><?= esc($profil['idt_codepostale_vil'] ?? 'Non renseigné') ?></div>
                        </div>
                        
                        <div class="alert alert-info mt-4">
                            <i class="fas fa-info-circle"></i> Pour modifier vos informations, veuillez contacter l'administrateur.
                        </div>
                    <?php else: ?>
                        <div class="alert alert-warning" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> Aucune information de profil disponible.
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Fin container-fluid -->
