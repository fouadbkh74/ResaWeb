<form action="<?= base_url('index.php/admin/envoyer_reponse/'.$msg_code) ?>" method="post">
    <?= csrf_field() ?>
    <div class="mb-3">
        <label for="reponse">Votre Réponse :</label>
        <textarea name="reponse" id="reponse" class="form-control" rows="4"><?= esc($msg_reponse) ?></textarea>
    </div>
    <div class="d-flex justify-content-center">
        <button type="submit" class="btn btn-success">Envoyer la réponse</button>
    </div>
</form>
