<!-- admin/affichage_messages.php -->

<?php
// Récupérer les erreurs de validation (passées directement depuis le contrôleur)
$validation_errors = $validation_errors ?? null;
$old_input = $old_input ?? null;
?>

<style>
/* Cacher tous les formulaires par défaut */
.formulaire-reponse {
    display: none;
    background-color: #f8f9fa;
    padding: 20px;
    border-left: 4px solid #28a745;
    margin: 10px 0;
}

/* Afficher le formulaire ciblé */
.formulaire-reponse:target {
    display: block;
    animation: slideDown 0.3s ease;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>

<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800"><?= $titre ?></h1>
    <p class="mb-4">Liste de tous les messages reçus par les membres. Vous pouvez répondre ou supprimer un message.</p>

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

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Messages</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Email</th>
                            <th>Sujet</th>
                            <th>Message</th>
                            <th>Date</th>
                            <th>Réponse</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Code</th>
                            <th>Email</th>
                            <th>Sujet</th>
                            <th>Message</th>
                            <th>Date</th>
                            <th>Réponse</th>
                            <th>Actions</th>
                        </tr>
                    </tfoot>
                    <tbody> 
                        <?php if (!empty($messages) && is_array($messages)) : ?>
                            <?php foreach ($messages as $msg) : ?>
                                <tr>
                                    <td><?= esc($msg['idt_Message_msg']); ?></td>
                                    <td><?= esc($msg['msg_email']); ?></td>
                                    <td><?= esc($msg['msg_sujet']); ?></td>
                                    <td><?= esc($msg['msg_contenue']); ?></td>
                                    <td><?= esc($msg['msg_date_envoie']); ?></td>
                                    <td>
                                        <?= !empty($msg['msg_repense']) ? esc($msg['msg_repense']) : '<em class="text-muted">Aucune réponse</em>'; ?>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-success btn-sm" data-toggle="modal" data-target="#modalReponse-<?= esc($msg['msg_code']); ?>" title="Répondre">
                                            <i class="fas fa-reply"></i>
                                        </button>
                                        <a href="<?= base_url('index.php/admin/supprimer_message/'.$msg['msg_code']); ?>" class="btn btn-danger btn-sm" onclick="return confirm('Voulez-vous vraiment supprimer ce message ?');" title="Supprimer">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modales de réponse (générées en dehors du tableau) -->
    <?php if (!empty($messages) && is_array($messages)) : ?>
        <?php foreach ($messages as $msg) : ?>
            <div class="modal fade" id="modalReponse-<?= esc($msg['msg_code']); ?>" tabindex="-1" role="dialog" aria-labelledby="modalLabel-<?= esc($msg['msg_code']); ?>" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title" id="modalLabel-<?= esc($msg['msg_code']); ?>">
                                <i class="fas fa-reply"></i> Répondre à <?= esc($msg['msg_email']); ?>
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <form method="post" action="<?= base_url('index.php/admin/envoyer_reponse_modal'); ?>">
                            <div class="modal-body">
                                <?= csrf_field() ?>
                                <input type="hidden" name="msg_code" value="<?= esc($msg['msg_code']); ?>">
                                
                                <!-- Affichage des erreurs de validation -->
                                <?php if ($validation_errors && $old_input && isset($old_input['msg_code']) && $old_input['msg_code'] == $msg['msg_code']): ?>
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <strong>Erreur de validation :</strong>
                                        <ul class="mb-0">
                                            <?php foreach ($validation_errors as $error): ?>
                                                <li><?= esc($error) ?></li>
                                            <?php endforeach; ?>
                                        </ul>
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                <?php endif; ?>
                                
                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <p class="mb-1"><strong>Sujet :</strong> <?= esc($msg['msg_sujet']); ?></p>
                                                <p class="mb-0"><strong>Message :</strong> <?= esc($msg['msg_contenue']); ?></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="reponse-input-<?= esc($msg['msg_code']); ?>"><strong>Votre Réponse :</strong></label>
                                    <textarea 
                                        name="reponse" 
                                        id="reponse-input-<?= esc($msg['msg_code']); ?>" 
                                        class="form-control <?= ($validation_errors && $old_input && isset($old_input['msg_code']) && $old_input['msg_code'] == $msg['msg_code'] && isset($validation_errors['reponse'])) ? 'is-invalid' : '' ?>" 
                                        rows="5" 
                                        placeholder="Tapez votre réponse ici..."
                                      
                                    ><?= $old_input['reponse'] ?? esc($msg['msg_repense'] ?? ''); ?></textarea>
                                    <?php if ($validation_errors && $old_input && isset($old_input['msg_code']) && $old_input['msg_code'] == $msg['msg_code'] && isset($validation_errors['reponse'])): ?>
                                        <div class="invalid-feedback d-block">
                                            <?= esc($validation_errors['reponse']) ?>
                                        </div>
                                    <?php endif; ?>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Annuler</button>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-paper-plane"></i> Envoyer
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>

</div>
<!-- Fin container-fluid -->

</div>
<!-- Fin Main Content -->