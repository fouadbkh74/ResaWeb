<br><br><br><br><br><br><br><br><br><br><br>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="card shadow-lg p-4">
                <div class="card-body">
                    <h2 class="text-center mb-4"><?php echo $titre; ?></h2>


                    <!-- Affichage des erreurs de connexion -->
                    <?php if (session()->getFlashdata('error')): ?>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle"></i>
                            <?= session()->getFlashdata('error') ?>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    <?php endif; ?>

                    <!-- Formulaire avec Bootstrap -->
                    <?php echo form_open('/compte/connecter'); ?>
                    <?= csrf_field() ?>

                    <!-- Champ pseudo -->
                    <div class="mb-3">
                        <label for="pseudo" class="form-label">Pseudo :</label>
                        <input type="text" name="pseudo" class="form-control" id="pseudo"
                               value="<?= set_value('pseudo') ?>">
                        <?= validation_show_error('pseudo') ?>
                    </div>

                    <!-- Champ mot de passe -->
                    <div class="mb-3">
                        <label for="mdp" class="form-label">Mot de passe :</label>
                        <input type="password" name="mdp" class="form-control" id="mdp">
                        <?= validation_show_error('mdp') ?>
                    </div>

                    <!-- Bouton de soumission (vert) -->
                    <div class="d-flex justify-content-center">
                        <input type="submit" name="submit" value="Se connecter" class="btn btn-success">
                    </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<br><br><br><br><br><br><br><br><br>