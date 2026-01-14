<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800"><?= $titre ?></h1>
    <p class="mb-4">Liste de tous les adhérents de l'association.</p>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Adhérents</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <?php if (!empty($adherents) && is_array($adherents)) : ?>
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                        </tr>
                    </tfoot>
                    <tbody>
                        <?php foreach ($adherents as $adherent) : ?>
                            <tr>
                                <td><?= esc($adherent['pfl_Nom'] ?? 'Non renseigné'); ?></td>
                                <td><?= esc($adherent['pfl_prenom'] ?? 'Non renseigné'); ?></td>
                                <td><a href="mailto:<?= esc($adherent['pfl_email']); ?>"><?= esc($adherent['pfl_email']); ?></a></td>
                                <td><a href="tel:<?= esc($adherent['pfl_numTel']); ?>"><?= esc($adherent['pfl_numTel'] ?? 'Non renseigné'); ?></a></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
                <?php else: ?>
                    <div class="alert alert-info mt-3">
                        Aucun adhérent pour le moment !
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

</div>
<!-- Fin container-fluid -->
