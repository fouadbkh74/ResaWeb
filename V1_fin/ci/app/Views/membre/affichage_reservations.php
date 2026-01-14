<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800"><?= $titre ?></h1>
    <p class="mb-4">Liste de vos réservations à venir. (ID Connecté : <?= session()->get('id') ?>)</p>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Mes Réservations</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Date</th>
                            <th>Heure</th>
                            <th>Lieu</th>
                            <th>Bilan</th>
                            <th>Ressource</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Date</th>
                            <th>Heure</th>
                            <th>Lieu</th>
                            <th>Bilan</th>
                            <th>Ressource</th>
                        </tr>
                    </tfoot>
                    <tbody>
                        <?php if (!empty($reservations) && is_array($reservations)) : ?>
                            <?php foreach ($reservations as $res) : ?>
                                <tr>
                                    <td><?= esc($res['idt_Reservation_res']); ?></td>
                                    <td><?= esc($res['res_nom']); ?></td>
                                    <td><?= date('d/m/Y', strtotime($res['res_date'])); ?></td>
                                    <td><?= date('H:i', strtotime($res['res_heur'])); ?></td>
                                    <td><?= esc($res['res_lieu']); ?></td>
                                    <td><?= esc($res['res_bilan']); ?></td>
                                    <td><?= esc($res['ressource_nom'] ?? 'Non définie'); ?></td>
                                </tr>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>
<!-- Fin container-fluid -->
