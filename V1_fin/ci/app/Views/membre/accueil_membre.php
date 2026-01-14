                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800"><?= isset($titre) ? esc($titre) : 'Tableau de bord' ?></h1>
                    </div>

                    <!-- Content Row -->
                    <div class="row">

                        <!-- Carte de bienvenue -->
                        <div class="col-xl-12 col-lg-12">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Bienvenue, <?php $session = session(); echo $session->get('user') ?? 'Membre'; ?> !</h6>
                                </div>
                                <div class="card-body">
                                    <p>Vous êtes connecté en tant que <strong>Membre</strong>.</p>
                                    <p>Utilisez le menu ci-dessus pour accéder à vos fonctionnalités.</p>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Contenu dynamique (sera remplacé par les vues spécifiques) -->
                    <?php if (isset($contenu_page)) : ?>
                        <?= $contenu_page ?>
                    <?php endif; ?>

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->

            <!-- Page Heading -->
<div class="container-fluid">
    <h2><p class="mb-4">Liste de vos réservations à venir.</p></h2>

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
