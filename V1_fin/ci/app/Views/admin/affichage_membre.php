<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Comptes/Profils</h1>
    
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

    <?php if (session()->getFlashdata('info')): ?>
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <?= session()->getFlashdata('info') ?>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    <?php endif; ?>

    <p class="mb-4">Ci-dessous la liste des membres actifs enregistrés dans le système.</p>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Gestion des Comptes / Profils</h6>
            <div>
                <!-- Bouton Ajouter Invité (Actif) -->
                <a href="<?= base_url('index.php/admin/create_compte_invite') ?>" class="btn btn-success btn-sm">
                    <i class="fas fa-user-plus"></i> Ajouter un compte invité
                </a>
                
                <!-- Bouton Ajouter Compte/Profil (Inactif pour Sprint 1) -->
                <button class="btn btn-secondary btn-sm" disabled title="Bientôt disponible">
                    <i class="fas fa-plus"></i> Ajouter un compte/profil
                </button>
            </div>
        </div>

        <div class="card-body">
            <?php if (empty($logins)): ?>
                <div class="alert alert-warning text-center" role="alert">
                    <i class="fas fa-exclamation-circle"></i> Aucun compte/profil pour le moment !
                </div>
            <?php else: ?>
                <div class="table-responsive">
                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">

                    <thead class="bg-primary text-white">
                        <tr>
                            <th>ID</th>
                            <th>Pseudo</th>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                            <th>Rôle</th>
                            <th>État</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>ID</th>
                            <th>Pseudo</th>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                            <th>Rôle</th>
                            <th>État</th>
                            <th>Actions</th>
                        </tr>
                    </tfoot>

                    <tbody>
                        <?php if (!empty($logins)) : ?>
                            <?php foreach ($logins as $membre) : ?>
                                <tr>
                                    <td><?= $membre['idt_compte_cpt'] ?></td>
                                    <td><?= $membre['cpt_pseudo'] ?></td>
                                    <td><?= $membre['pfl_Nom'] ?? '<em class="text-muted">N/A</em>' ?></td>
                                    <td><?= $membre['pfl_prenom'] ?? '<em class="text-muted">N/A</em>' ?></td>
                                    <td><?= $membre['pfl_email'] ?? '<em class="text-muted">N/A</em>' ?></td>
                                    <td><?= $membre['pfl_numTel'] ?? '<em class="text-muted">N/A</em>' ?></td>
                                    <td>
                                        <?php if ($membre['cpt_Role'] == 'invite'): ?>
                                            <span class="badge badge-info">Invité</span>
                                        <?php else: ?>
                                            <?= $membre['cpt_Role'] ?>
                                        <?php endif; ?>
                                    </td>
                                    <td>
                                        <?php if ($membre['cpt_etat'] == 'A') : ?>
                                            <span class="badge badge-success">Actif</span>
                                        <?php else : ?>
                                            <span class="badge badge-danger">Inactif</span>
                                        <?php endif; ?>
                                    </td>

                                    <!-- === ACTION BUTTONS === -->
                                <td class="text-center">

                                    <!-- Voir (Modale) - ACTIF -->
                                    <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#modalVoir-<?= $membre['idt_compte_cpt'] ?>" title="Voir les détails">
                                        <i class="fas fa-eye"></i>
                                    </button>

                                    <!-- Modifier (Désactivé pour SPRINT 1) -->
                                    <button class="btn btn-warning btn-sm" disabled title="Fonctionnalité disponible dans un prochain sprint">
                                        <i class="fas fa-edit"></i>
                                    </button>

                                    <!-- Désactiver/Activer (Désactivé pour SPRINT 1) -->
                                    <button class="btn btn-secondary btn-sm" disabled title="Fonctionnalité disponible dans un prochain sprint">
                                        <i class="fas fa-ban"></i>
                                    </button>

                                    <!-- Supprimer -->
                                    <!-- Supprimer -->
                                    <a href="#" 
                                       class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce compte ? Cette action est irréversible !')"
                                       title="Supprimer le compte">
                                        <i class="fas fa-trash"></i>
                                    </a>

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
    <!-- Modales Voir Membre -->
    <?php if (!empty($logins)) : ?>
        <?php foreach ($logins as $membre) : ?>
            <div class="modal fade" id="modalVoir-<?= $membre['idt_compte_cpt'] ?>" tabindex="-1" role="dialog" aria-labelledby="modalLabelVoir-<?= $membre['idt_compte_cpt'] ?>" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-info text-white">
                            <h5 class="modal-title" id="modalLabelVoir-<?= $membre['idt_compte_cpt'] ?>">
                                <i class="fas fa-user"></i> Détails du membre : <?= esc($membre['cpt_pseudo']) ?>
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <tbody>
                                        <tr>
                                            <th>ID</th>
                                            <td><?= esc($membre['idt_compte_cpt']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Pseudo</th>
                                            <td><?= esc($membre['cpt_pseudo']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Nom</th>
                                            <td><?= esc($membre['pfl_Nom']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Prénom</th>
                                            <td><?= esc($membre['pfl_prenom']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Email</th>
                                            <td><a href="mailto:<?= esc($membre['pfl_email']) ?>"><?= esc($membre['pfl_email']) ?></a></td>
                                        </tr>
                                        <tr>
                                            <th>Téléphone</th>
                                            <td><?= esc($membre['pfl_numTel']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Adresse</th>
                                            <td><?= esc($membre['pfl_adresse']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>Rôle</th>
                                            <td><?= esc($membre['cpt_Role']) ?></td>
                                        </tr>
                                        <tr>
                                            <th>État</th>
                                            <td>
                                                <?php if ($membre['cpt_etat'] == 'A') : ?>
                                                    <span class="badge badge-success">Actif</span>
                                                <?php else : ?>
                                                    <span class="badge badge-danger">Inactif</span>
                                                <?php endif; ?>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Fermer</button>
                            <a href="<?= site_url('admin/modifier_membre/' . $membre['idt_compte_cpt']) ?>" class="btn btn-warning">
                                <i class="fas fa-edit"></i> Modifier
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>

</div>
<!-- Fin container-fluid -->

</div>
<!-- Fin Main Content -->

<!-- Script pour configurer le tri par défaut de DataTables -->
<script>
$(document).ready(function() {
    // Détruire l'instance DataTables existante si elle existe
    if ($.fn.DataTable.isDataTable('#dataTable')) {
        $('#dataTable').DataTable().destroy();
    }
    
    // Réinitialiser DataTables avec tri par ID (colonne 0) croissant
    $('#dataTable').DataTable({
        "order": [[0, "asc"]],  // Trier par la colonne 0 (ID) en ordre croissant
        "language": {
            "url": "//cdn.datatables.net/plug-ins/1.10.24/i18n/French.json"
        }
    });
});
</script>
