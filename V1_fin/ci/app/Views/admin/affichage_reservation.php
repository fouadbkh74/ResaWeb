<div class="container-fluid">

    <!-- Page Heading avec Datepicker -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-2 text-gray-800"><?= $titre ?></h1>
            <p class="mb-0">Liste des réservations à venir.</p>
        </div>
        <div class="card shadow" style="width: 320px;">
            <div class="card-body">
                <h6 class="font-weight-bold text-primary mb-3">
                    <i class="fas fa-calendar-alt"></i> Filtrer par date
                </h6>
                <form method="GET" action="<?= base_url('index.php/admin/lister_reservations') ?>">
                    <input type="date" 
                           name="date_filtre" 
                           class="form-control mb-2"
                           value="<?= isset($date_selectionnee) ? $date_selectionnee : '' ?>">
                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-search"></i> Rechercher
                    </button>
                    <?php if (isset($date_selectionnee) && !empty($date_selectionnee)): ?>
                        <a href="<?= base_url('index.php/admin/lister_reservations') ?>" 
                           class="btn btn-secondary btn-block btn-sm mt-2">
                            <i class="fas fa-times"></i> Réinitialiser
                        </a>
                    <?php endif; ?>
                </form>
            </div>
        </div>
    </div>

    <!-- Messages Flash -->
    <?php if (session()->getFlashdata('success')): ?>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <?= session()->getFlashdata('success') ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    <?php endif; ?>

    <?php if (session()->getFlashdata('error')): ?>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <?= session()->getFlashdata('error') ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    <?php endif; ?>

    <!-- Tableau filtré par date -->
    <?php if (isset($reservations_filtrees) && !empty($reservations_filtrees)): ?>
        <div class="card shadow mb-4">
            <div class="card-header py-3 bg-success text-white">
                <h6 class="m-0 font-weight-bold">
                    <i class="fas fa-calendar-check"></i> Réservations du <?= date('d/m/Y', strtotime($date_selectionnee)) ?>
                </h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="bg-primary text-white">
                            <tr>
                                <th>Ressource</th>
                                <th>Heure</th>
                                <th>Email Responsable</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($reservations_filtrees as $res): ?>
                                <tr>
                                    <td><strong><?= esc($res['ressource'] ?? 'Non définie') ?></strong></td>
                                    <td><i class="fas fa-clock"></i> <?= esc($res['heure']) ?></td>
                                    <td><i class="fas fa-envelope"></i> <?= esc($res['email_responsable'] ?? 'Non défini') ?></td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    <?php elseif (isset($date_selectionnee) && !empty($date_selectionnee)): ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> Aucune réservation pour le <?= date('d/m/Y', strtotime($date_selectionnee)) ?>
        </div>
    <?php endif; ?>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Réservations</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                    <thead class="bg-primary text-white">
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Responsable</th>
                            <th>Date</th>
                            <th>Heure</th>
                            <th>Lieu</th>
                            <th>Bilan</th>
                            <th>Ressource</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($reservations) && is_array($reservations)) : ?>
                            <?php foreach ($reservations as $res) : ?>
                                <tr>
                                    <td><?= esc($res['idt_Reservation_res']); ?></td>
                                    <td><?= esc($res['res_nom']); ?></td>
                                    <td>
                                        <?php if (!empty($res['responsable'])): ?>
                                            <span class="badge badge-primary">
                                                <i class="fas fa-user-tie"></i> <?= esc($res['responsable']); ?>
                                            </span>
                                        <?php else: ?>
                                            <em class="text-muted">Non défini</em>
                                        <?php endif; ?>
                                    </td>
                                    <td><?= esc($res['res_date']); ?></td>
                                    <td><?= esc($res['res_heur']); ?></td>
                                    <td><?= esc($res['res_lieu']); ?></td>
                                    <td><?= esc($res['res_bilan']); ?></td>
                                    <td><?= esc($res['ressource_nom'] ?? 'Non définie'); ?></td>
                                    <td>
                                        <?php if ($res['statut'] == 'Actif'): ?>
                                            <span class="badge badge-success">Actif</span>
                                        <?php else: ?>
                                            <span class="badge badge-secondary">Désactivé</span>
                                        <?php endif; ?>
                                    </td>
                                    <td class="text-center">
                                        <button type="button" 
                                                class="btn btn-info btn-sm" 
                                                data-toggle="modal" 
                                                data-target="#modalParticipants-<?= $res['idt_Reservation_res'] ?>"
                                                title="Voir les participants">
                                            <i class="fas fa-users"></i> Participants
                                        </button>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="10" class="text-center">Aucune réservation à venir</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>
<!-- End of Main Content -->

<!-- Modales pour les participants -->
<?php if (!empty($reservations) && is_array($reservations)) : ?>
    <?php 
    $model = model(\App\Models\Db_model::class);
    foreach ($reservations as $res) : 
        $participants = $model->get_participants_reservation($res['idt_Reservation_res']);
    ?>
        <div class="modal fade" id="modalParticipants-<?= $res['idt_Reservation_res'] ?>" tabindex="-1" role="dialog" aria-labelledby="modalParticipantsLabel-<?= $res['idt_Reservation_res'] ?>" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title" id="modalParticipantsLabel-<?= $res['idt_Reservation_res'] ?>">
                            <i class="fas fa-users"></i> Participants - <?= esc($res['res_nom']) ?>
                        </h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <strong>Date :</strong> <?= esc($res['res_date']) ?> à <?= esc($res['res_heur']) ?><br>
                            <strong>Lieu :</strong> <?= esc($res['res_lieu']) ?>
                        </div>
                        <hr>
                        <?php if (!empty($participants)): ?>
                            <div class="table-responsive">
                                <table class="table table-striped table-sm">
                                    <thead>
                                        <tr>
                                            <th>Pseudo</th>
                                            <th>Nom</th>
                                            <th>Prénom</th>
                                            <th>Email</th>
                                            <th>Téléphone</th>
                                            <th>Rôle</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($participants as $participant): ?>
                                            <tr>
                                                <td><?= esc($participant['cpt_pseudo']) ?></td>
                                                <td><?= esc($participant['pfl_Nom'] ?? 'N/A') ?></td>
                                                <td><?= esc($participant['pfl_prenom'] ?? 'N/A') ?></td>
                                                <td><?= esc($participant['pfl_email'] ?? 'N/A') ?></td>
                                                <td><?= esc($participant['pfl_numTel'] ?? 'N/A') ?></td>
                                                <td>
                                                    <?php if ($participant['cpt_res_Role'] == 'R'): ?>
                                                        <span class="badge badge-primary">Responsable</span>
                                                    <?php else: ?>
                                                        <span class="badge badge-secondary">Participant</span>
                                                    <?php endif; ?>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                            <div class="alert alert-info mt-3">
                                <i class="fas fa-info-circle"></i> <strong>Total :</strong> <?= count($participants) ?> participant(s)
                            </div>
                        <?php else: ?>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle"></i> Aucun participant pour cette réservation.
                            </div>
                        <?php endif; ?>
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
<!-- End of Content Wrapper -->
