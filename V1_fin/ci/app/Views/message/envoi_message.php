<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="card shadow-lg p-4">
                <div class="card-body">
                    <h2 class="text-center mb-4"></h2>
                    
                    <!-- Affichage des erreurs -->
                    <?= session()->getFlashdata('error') ?>

                    <!-- Formulaire avec Bootstrap -->
                    <?php
                        echo form_open('/message/envoyer'); 
                    ?>

                    <?= csrf_field() ?>

                    <!-- Champ email -->
                    <div class="mb-3">
                        <label for="email" class="form-label">Adresse Email :</label>
                        <input type="email" name="email" class="form-control" id="email" value="<?= set_value('email') ?>" required>
                        <?= validation_show_error('email') ?>
                    </div>

                    <!-- Champ sujet -->
                    <div class="mb-3">
                        <label for="sujet" class="form-label">Sujet :</label>
                        <input type="text" name="sujet" class="form-control" id="sujet" value="<?= set_value('sujet') ?>" required>
                        <?= validation_show_error('sujet') ?>
                    </div>

                    <!-- Champ contenu (textarea) -->
                    <div class="mb-3">
                        <label for="contenu" class="form-label">Contenu du message :</label>
                        <textarea name="contenu" class="form-control" id="contenu" rows="4" required><?= set_value('contenu') ?></textarea>
                        <?= validation_show_error('contenu') ?>
                    </div>

                    <!-- Bouton de soumission -->
                    <div class="d-flex justify-content-center">
                        <input type="submit" name="submit" value="Envoyer le message" class="btn btn-success">
                    </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
