<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800"><?= $titre ?></h1>
    <p class="mb-4">Consultez les réservations des ressources pour une date donnée.</p>

    <!-- Formulaire de sélection de date -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 bg-primary text-white">
            <h6 class="m-0 font-weight-bold">
                <i class="fas fa-calendar-alt"></i> Choisir une date
            </h6>
        </div>
        <div class="card-body">
            <form method="GET" action="<?= base_url('index.php/utilisateur/seances_reservees') ?>">
                <div class="row">
                    <div class="col-md-8">
                        <div class="form-group">
                            <label for="date_choisie"><strong>Sélectionnez une date :</strong></label>
                            <input type="date" 
                                   name="date_choisie" 
                                   id="date_choisie" 
                                   class="form-control" 
                                   value="<?= esc($date_choisie) ?>" 
                                   required>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <div class="form-group w-100">
                            <button type="submit" class="btn btn-primary btn-block">
                                <i class="fas fa-search"></i> Voir les réservations
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Affichage des réservations par ressource -->
    <?php if (!empty($date_choisie)): ?>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> 
            <strong>Réservations du <?= date('d/m/Y', strtotime($date_choisie)) ?></strong>
        </div>

        <?php if (empty($reservations_par_ressource)): ?>
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i> 
                <strong>Aucune réservation pour l'instant !</strong>
            </div>
        <?php else: ?>
            <?php foreach ($reservations_par_ressource as $ressource_id => $ressource): ?>
                <div class="card shadow mb-4">
                    <div class="card-header py-3 bg-success text-white">
                        <div class="d-flex align-items-center">
                            <!-- Photo de la ressource -->
                            <?php if (!empty($ressource['photo'])): ?>
                                <img src="<?= base_url('index.php/admin/get_image/' . esc($ressource['photo'])) ?>" 
                                     alt="Photo ressource" 
                                     class="img-thumbnail mr-3" 
                                     style="width: 60px; height: 60px; object-fit: cover;">
                            <?php else: ?>
                                <div class="bg-white text-success d-flex align-items-center justify-content-center mr-3" 
                                     style="width: 60px; height: 60px; border-radius: 5px;">
                                    <i class="fas fa-image fa-2x"></i>
                                </div>
                            <?php endif; ?>
                            
                            <!-- Nom de la ressource -->
                            <div>
                                <h6 class="m-0 font-weight-bold">
                                    <i class="fas fa-cube"></i> <?= esc($ressource['nom']) ?>
                                </h6>
                                <?php if (!empty($ressource['materiels'])): ?>
                                    <small class="d-block mt-1"><?= esc($ressource['materiels']) ?></small>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <?php foreach ($ressource['reservations'] as $reservation): ?>
                            <div class="border rounded p-3 mb-3 bg-light">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h5 class="text-primary">
                                            <i class="fas fa-clock"></i> <?= esc($reservation['heure']) ?>
                                        </h5>
                                        <p class="mb-2">
                                            <strong>Responsable :</strong> 
                                            <span class="badge badge-primary">
                                                <?= esc($reservation['responsable']) ?>
                                            </span>
                                            <?php if (!empty($reservation['responsable_nom'])): ?>
                                                <br>
                                                <small class="text-muted">
                                                    <?= esc($reservation['responsable_prenom']) ?> <?= esc($reservation['responsable_nom']) ?>
                                                </small>
                                            <?php endif; ?>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p class="mb-2">
                                            <strong>Participants :</strong>
                                            <button type="button" 
                                                    class="btn btn-info btn-sm ml-2" 
                                                    data-toggle="modal" 
                                                    data-target="#modalParticipants-<?= $reservation['id'] ?>">
                                                <i class="fas fa-users"></i> 
                                                Voir la liste (<?= count($reservation['participants']) ?>)
                                            </button>
                                        </p>
                                    </div>
                                </div>

                                <!-- Affichage du bilan si la séance est passée -->
                                <?php 
                                $date_reservation = strtotime($reservation['date']);
                                $aujourd_hui = strtotime(date('Y-m-d'));
                                ?>
                                <?php if ($date_reservation < $aujourd_hui && !empty($reservation['bilan'])): ?>
                                    <div class="mt-3 p-2 bg-white border-left border-primary">
                                        <h6 class="text-primary">
                                            <i class="fas fa-file-alt"></i> Bilan de la séance :
                                        </h6>
                                        <p class="mb-0"><?= nl2br(esc($reservation['bilan'])) ?></p>
                                    </div>
                                <?php endif; ?>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            <?php endforeach; ?>
        <?php endif; ?>
    <?php endif; ?>

</div>
<!-- End of Main Content -->

<!-- Modales des participants (en dehors de la structure principale) -->
<?php if (!empty($date_choisie) && !empty($reservations_par_ressource)): ?>
    <?php foreach ($reservations_par_ressource as $ressource_id => $ressource): ?>
        <?php foreach ($ressource['reservations'] as $reservation): ?>
            <div class="modal fade" id="modalParticipants-<?= $reservation['id'] ?>" tabindex="-1" role="dialog" aria-labelledby="modalLabel-<?= $reservation['id'] ?>">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-info text-white">
                            <h5 class="modal-title" id="modalLabel-<?= $reservation['id'] ?>">
                                <i class="fas fa-users"></i> Liste des participants - <?= esc($reservation['heure']) ?>
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Fermer">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <?php if (!empty($reservation['participants']) && is_array($reservation['participants'])): ?>
                                <div class="table-responsive">
                                    <table class="table table-striped table-sm">
                                        <thead class="bg-light">
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
                                            <?php foreach ($reservation['participants'] as $participant): ?>
                                                <tr>
                                                    <td><strong><?= esc($participant['cpt_pseudo']) ?></strong></td>
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
                                <div class="alert alert-info mt-3 mb-0">
                                    <i class="fas fa-info-circle"></i> 
                                    <strong>Total :</strong> <?= count($reservation['participants']) ?> participant(s)
                                </div>
                            <?php else: ?>
                                <div class="alert alert-warning mb-0">
                                    <i class="fas fa-exclamation-triangle"></i> 
                                    Aucun participant pour cette réservation.
                                </div>
                            <?php endif; ?>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                <i class="fas fa-times"></i> Fermer
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endforeach; ?>
<?php endif; ?>
