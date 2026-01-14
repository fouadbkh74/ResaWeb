<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Gestion des Ressources</h1>
    
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

    <p class="mb-4">Ci-dessous la liste des ressources disponibles dans le système.</p>

    <!-- Card Ressources -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Liste des Ressources</h6>
            <div>
                <!-- Bouton Ajouter Ressource -->
                <button class="btn btn-success btn-sm" data-toggle="modal" data-target="#modalAjouterRessource">
                    <i class="fas fa-plus"></i> Ajouter une ressource
                </button>
            </div>
        </div>

        <div class="card-body">
            <?php if (empty($ressources)): ?>
                <div class="alert alert-warning text-center" role="alert">
                    <i class="fas fa-exclamation-circle"></i> Aucune ressource pour le moment !
                </div>
            <?php else: ?>
                <div class="table-responsive">
                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">

                    <thead class="bg-primary text-white">
                        <tr>
                            <th>ID</th>
                            <th>Photo</th>
                            <th>Type</th>
                            <th>Matériels</th>
                            <th>Jauge</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>ID</th>
                            <th>Photo</th>
                            <th>Type</th>
                            <th>Matériels</th>
                            <th>Jauge</th>
                            <th>Actions</th>
                        </tr>
                    </tfoot>

                    <tbody>
                        <?php if (!empty($ressources)) : ?>
                            <?php foreach ($ressources as $ressource) : ?>
                                <tr>
                                    <td><?= $ressource['idt_Ressources_rcs'] ?></td>
                                    <td class="text-center">
                                        <?php if (!empty($ressource['rcs_photo'])): ?>
                                            <img src="<?= base_url('index.php/admin/get_image/' . esc($ressource['rcs_photo'])) ?>" 
                                                 alt="Photo ressource" 
                                                 class="img-thumbnail" 
                                                 style="width: 120px; height: 120px; object-fit: cover; cursor: pointer;"
                                                 data-toggle="modal" 
                                                 data-target="#modalVoir-<?= $ressource['idt_Ressources_rcs'] ?>">
                                        <?php else: ?>
                                            <div class="bg-secondary text-white d-flex align-items-center justify-content-center" 
                                                 style="width: 120px; height: 120px;">
                                                <i class="fas fa-image fa-3x"></i>
                                            </div>
                                        <?php endif; ?>
                                    </td>
                                    <td><strong><?= esc($ressource['rcs_type']) ?></strong></td>
                                    <td><?= esc($ressource['rcs_listeMateriels']) ?></td>
                                    <td>
                                        <span class="badge badge-info">
                                            <i class="fas fa-users"></i> <?= esc($ressource['rcs_jauge']) ?>
                                        </span>
                                    </td>

                                    <!-- === ACTION BUTTONS === -->
                                <td class="text-center">

                                    <!-- Upload Photo -->
                                    <button type="button" 
                                            class="btn btn-warning btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#modalUploadPhoto-<?= $ressource['idt_Ressources_rcs'] ?>" 
                                            title="Uploader une photo">
                                        <i class="fas fa-camera"></i>
                                    </button>

                                    <!-- Voir -->
                                    <button type="button" 
                                            class="btn btn-info btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#modalVoir-<?= $ressource['idt_Ressources_rcs'] ?>" 
                                            title="Voir les détails">
                                        <i class="fas fa-eye"></i>
                                    </button>

                                    <!-- Modifier -->
                                    <button type="button" 
                                            class="btn btn-primary btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#modalModifier-<?= $ressource['idt_Ressources_rcs'] ?>" 
                                            title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </button>

                                    <!-- Supprimer -->
                                    <button type="button" 
                                            class="btn btn-danger btn-sm" 
                                            onclick="confirmerSuppression(<?= $ressource['idt_Ressources_rcs'] ?>)" 
                                            title="Supprimer">
                                        <i class="fas fa-trash"></i>
                                    </button>

                                </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </tbody>

                </table>

            </div>
            <?php endif; ?>
        </div>
    </div>

    <!-- Modales Upload Photo -->
    <?php if (!empty($ressources)) : ?>
        <?php foreach ($ressources as $ressource) : ?>
            <div class="modal fade" id="modalUploadPhoto-<?= $ressource['idt_Ressources_rcs'] ?>" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-warning text-white">
                            <h5 class="modal-title">
                                <i class="fas fa-camera"></i> Upload Photo - <?= esc($ressource['rcs_type']) ?>
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <form action="<?= base_url('index.php/admin/upload_photo_ressource/' . $ressource['idt_Ressources_rcs']) ?>" 
                              method="post" 
                              enctype="multipart/form-data">
                            <?= csrf_field() ?>
                            <div class="modal-body">
                                <?php if (!empty($ressource['rcs_photo'])): ?>
                                    <div class="text-center mb-3">
                                        <p><strong>Photo actuelle :</strong></p>
                                        <img src="<?= base_url('index.php/admin/get_image/' . esc($ressource['rcs_photo'])) ?>" 
                                             alt="Photo actuelle" 
                                             class="img-thumbnail" 
                                             style="max-width: 270px;">
                                    </div>
                                <?php endif; ?>
                                
                                <div class="form-group">
                                    <label for="photo"><strong>Sélectionner une nouvelle photo</strong></label>
                                    <input type="file" 
                                           class="form-control-file" 
                                           id="photo" 
                                           name="photo" 
                                           accept="image/*" 
                                           required>
                                    <small class="form-text text-muted">
                                        Formats acceptés : JPG, PNG, GIF (Max 2MB)
                                    </small>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Annuler</button>
                                <button type="submit" class="btn btn-warning">
                                    <i class="fas fa-upload"></i> Upload
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>

    <!-- Modales Voir Détails -->
    <?php if (!empty($ressources)) : ?>
        <?php foreach ($ressources as $ressource) : ?>
            <div class="modal fade" id="modalVoir-<?= $ressource['idt_Ressources_rcs'] ?>" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-info text-white">
                            <h5 class="modal-title">
                                <i class="fas fa-info-circle"></i> Détails - <?= esc($ressource['rcs_type']) ?>
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-4 text-center">
                                    <?php if (!empty($ressource['rcs_photo'])): ?>
                                        <img src="<?= base_url('index.php/admin/get_image/' . esc($ressource['rcs_photo'])) ?>" 
                                             alt="Photo ressource" 
                                             class="img-thumbnail" 
                                             style="max-width: 100%;">
                                    <?php else: ?>
                                        <div class="bg-secondary text-white d-flex align-items-center justify-content-center" 
                                             style="width: 100%; height: 200px;">
                                            <i class="fas fa-image fa-4x"></i>
                                        </div>
                                    <?php endif; ?>
                                </div>
                                <div class="col-md-8">
                                    <table class="table table-striped">
                                        <tr>
                                            <th>ID</th>
                                            <td><?= $ressource['idt_Ressources_rcs'] ?></td>
                                        </tr>
                                        <tr>
                                            <th>Type</th>
                                            <td><?= esc($ressource['rcs_type']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Matériels</th>
                                            <td><?= esc($ressource['rcs_listeMateriels']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Jauge</th>
                                            <td><?= esc($ressource['rcs_jauge']) ?> personnes</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Fermer</button>
                        </div>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>

</div>
<!-- Fin container-fluid -->



<!-- Modales Modifier Ressource -->
<?php if (!empty($ressources)) : ?>
    <?php foreach ($ressources as $ressource) : ?>
        <div class="modal fade" id="modalModifier-<?= $ressource['idt_Ressources_rcs'] ?>" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-edit"></i> Modifier - <?= esc($ressource['rcs_type']) ?>
                        </h5>
                        <button type="button" class="close text-white" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <form action="<?= base_url('index.php/admin/modifier_ressource/' . $ressource['idt_Ressources_rcs']) ?>" method="post">
                        <?= csrf_field() ?>
                        <input type="hidden" name="form_action" value="edit">
                        <input type="hidden" name="ressource_id" value="<?= $ressource['idt_Ressources_rcs'] ?>">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="rcs_type_<?= $ressource['idt_Ressources_rcs'] ?>"><strong>Type *</strong></label>
                                <input type="text" 
                                       class="form-control <?= isset($validation_errors['rcs_type']) ? 'is-invalid' : '' ?>" 
                                       id="rcs_type_<?= $ressource['idt_Ressources_rcs'] ?>" 
                                       name="rcs_type" 
                                       value="<?= esc($ressource['rcs_type']) ?>">
                            </div>
                            
                            <div class="form-group">
                                <label for="rcs_listeMateriels_<?= $ressource['idt_Ressources_rcs'] ?>"><strong>Liste des matériels *</strong></label>
                                <input type="text" 
                                       class="form-control <?= isset($validation_errors['rcs_listeMateriels']) ? 'is-invalid' : '' ?>" 
                                       id="rcs_listeMateriels_<?= $ressource['idt_Ressources_rcs'] ?>" 
                                       name="rcs_listeMateriels" 
                                       value="<?= esc($ressource['rcs_listeMateriels']) ?>">
                            </div>
                            
                            <div class="form-group">
                                <label for="rcs_jauge_<?= $ressource['idt_Ressources_rcs'] ?>"><strong>Jauge (capacité) *</strong></label>
                                <input type="number" 
                                       class="form-control <?= isset($validation_errors['rcs_jauge']) ? 'is-invalid' : '' ?>" 
                                       id="rcs_jauge_<?= $ressource['idt_Ressources_rcs'] ?>" 
                                       name="rcs_jauge" 
                                       value="<?= esc($ressource['rcs_jauge']) ?>">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Annuler</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Enregistrer
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <?php endforeach; ?>
<?php endif; ?>

</div>
<!-- Fin Main Content -->

<!-- Modale Ajouter Ressource -->
<div class="modal fade" id="modalAjouterRessource" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">
                    <i class="fas fa-plus"></i> Ajouter une ressource
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <form action="<?= base_url('index.php/admin/ajouter_ressource') ?>" method="post">
                <?= csrf_field() ?>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="rcs_type"><strong>Type *</strong></label>
                        <input type="text" 
                               class="form-control <?= isset($validation_errors['rcs_type']) ? 'is-invalid' : '' ?>" 
                               id="rcs_type" 
                               name="rcs_type" 
                               value="<?= old('rcs_type') ?>"
                               placeholder="Ex: Salle de réunion, Jardin partagé...">
                        <?php if (isset($validation_errors['rcs_type'])): ?>
                            <div class="invalid-feedback">
                                <?= esc($validation_errors['rcs_type']) ?>
                            </div>
                        <?php endif; ?>
                    </div>
                    
                    <div class="form-group">
                        <label for="rcs_listeMateriels"><strong>Liste des matériels *</strong></label>
                        <textarea 
                               class="form-control <?= isset($validation_errors['rcs_listeMateriels']) ? 'is-invalid' : '' ?>" 
                               id="rcs_listeMateriels" 
                               name="rcs_listeMateriels" 
                               rows="3"
                               placeholder="Ex: Tables, Chaises, Projecteur..."><?= old('rcs_listeMateriels') ?></textarea>
                        <?php if (isset($validation_errors['rcs_listeMateriels'])): ?>
                            <div class="invalid-feedback">
                                <?= esc($validation_errors['rcs_listeMateriels']) ?>
                            </div>
                        <?php endif; ?>
                    </div>
                    
                    <div class="form-group">
                        <label for="rcs_jauge"><strong>Jauge (capacité) *</strong></label>
                        <input type="number" 
                               class="form-control <?= isset($validation_errors['rcs_jauge']) ? 'is-invalid' : '' ?>" 
                               id="rcs_jauge" 
                               name="rcs_jauge" 
                               value="<?= old('rcs_jauge') ?>"
                               placeholder="Ex: 20"
                               min="1">
                        <?php if (isset($validation_errors['rcs_jauge'])): ?>
                            <div class="invalid-feedback">
                                <?= esc($validation_errors['rcs_jauge']) ?>
                            </div>
                        <?php endif; ?>
                    </div>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> La photo pourra être ajoutée après la création de la ressource.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Ajouter
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function confirmerSuppression(id) {
    if (confirm('Êtes-vous sûr de vouloir supprimer cette ressource ?')) {
        window.location.href = '<?= base_url('index.php/admin/supprimer_ressource/') ?>' + id;
    }
}

// Rouvrir la modale en cas d'erreur de validation
$(document).ready(function() {
    <?php if (isset($show_modal_add) && $show_modal_add): ?>
        // Attendre que tout soit chargé avant d'ouvrir la modale
        setTimeout(function() {
            $('#modalAjouterRessource').modal('show');
        }, 100);
    <?php endif; ?>
    
    <?php if (isset($show_modal_edit_id) && $show_modal_edit_id): ?>
        // Attendre que tout soit chargé avant d'ouvrir la modale
        setTimeout(function() {
            $('#modalModifierRessource-<?= $show_modal_edit_id ?>').modal('show');
        }, 100);
    <?php endif; ?>
});
</script>
