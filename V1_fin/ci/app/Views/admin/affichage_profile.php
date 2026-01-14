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
        <!-- Carte Profil -->
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-primary text-white">
                    <h6 class="m-0 font-weight-bold">Photo de profil</h6>
                </div>
                <div class="card-body text-center">
                    <img class="img-profile rounded-circle mb-3" src="<?= base_url('bootstrap2/bootstrap2/img/undraw_profile.svg'); ?>" style="width: 150px; height: 150px;">
                    <h4><?= esc($profil['cpt_pseudo']) ?></h4>
                    <p class="text-muted"><?= esc($profil['cpt_Role']) ?></p>
                    <span class="badge badge-success">Compte Actif</span>
                </div>
            </div>
        </div>

        <!-- Détails Profil -->
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-primary text-white d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold">Informations Personnelles</h6>
                    <button class="btn btn-light btn-sm text-primary font-weight-bold" data-toggle="modal" data-target="#modalModifierProfil">
                        <i class="fas fa-edit"></i> Modifier
                    </button>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-sm-3 font-weight-bold">Nom :</div>
                        <div class="col-sm-9"><?= esc($profil['pfl_Nom']) ?></div>
                    </div>
                    <hr>
                    <div class="row mb-3">
                        <div class="col-sm-3 font-weight-bold">Prénom :</div>
                        <div class="col-sm-9"><?= esc($profil['pfl_prenom']) ?></div>
                    </div>
                    <hr>
                    <div class="row mb-3">
                        <div class="col-sm-3 font-weight-bold">Email :</div>
                        <div class="col-sm-9"><?= esc($profil['pfl_email']) ?></div>
                    </div>
                    <hr>
                    <div class="row mb-3">
                        <div class="col-sm-3 font-weight-bold">Téléphone :</div>
                        <div class="col-sm-9"><?= esc($profil['pfl_numTel']) ?></div>
                    </div>
                    <hr>
                    <div class="row mb-3">
                        <div class="col-sm-3 font-weight-bold">Date de naissance :</div>
                        <div class="col-sm-9"><?= esc($profil['pfl_date_ncs']) ?></div>
                    </div>
                    <hr>
                    <div class="row mb-3">
                        <div class="col-sm-3 font-weight-bold">Adresse :</div>
                        <div class="col-sm-9"><?= esc($profil['pfl_adresse']) ?></div>
                    </div>
                    <hr>
                    <div class="row mb-3">
                        <div class="col-sm-3 font-weight-bold">Code Postal :</div>
                        <div class="col-sm-9"><?= esc($profil['idt_codepostale_vil']) ?></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Fin container-fluid -->

<!-- Modale Modification Profil -->
<div class="modal fade" id="modalModifierProfil" tabindex="-1" role="dialog" aria-labelledby="modalModifierProfilLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalModifierProfilLabel"><i class="fas fa-user-edit"></i> Modifier mes informations</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="<?= base_url('index.php/admin/valider_modification'); ?>" method="post">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="nom">Nom</label>
                            <input type="text" class="form-control" id="nom" name="nom" value="<?= esc($profil['pfl_Nom']) ?>">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="prenom">Prénom</label>
                            <input type="text" class="form-control" id="prenom" name="prenom" value="<?= esc($profil['pfl_prenom']) ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="<?= esc($profil['pfl_email']) ?>">
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="tel">Téléphone</label>
                            <input type="text" class="form-control" id="tel" name="tel" value="<?= esc($profil['pfl_numTel']) ?>">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="date_ncs">Date de naissance</label>
                            <input type="date" class="form-control" id="date_ncs" name="date_ncs" value="<?= esc($profil['pfl_date_ncs']) ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="adresse">Adresse</label>
                        <input type="text" class="form-control" id="adresse" name="adresse" value="<?= esc($profil['pfl_adresse']) ?>">
                    </div>
                    <div class="form-group">
                        <label for="cp">Code Postal</label>
                        <input type="text" class="form-control" id="cp" name="cp" value="<?= esc($profil['idt_codepostale_vil']) ?>">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
                </div>
            </form>
        </div>
    </div>
</div>

</div>
<!-- Fin Main Content -->
