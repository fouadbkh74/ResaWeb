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
                    <h2 class="text-center mb-4"><?php echo $titre; ?></h2>
                    
                    <!-- Affichage des erreurs -->
                    <?= session()->getFlashdata('error') ?>

                    <!-- Formulaire avec Bootstrap -->
                    <?php
                        echo form_open('/compte/creer'); 
                    ?>

                    <?= csrf_field() ?>

                    <!-- Champ pseudo -->
                    <div class="mb-3">
                        <label for="pseudo" class="form-label">Pseudo :</label>
                        <input type="text" name="pseudo" class="form-control" id="pseudo">
                        <?= validation_show_error('pseudo') ?>
                    </div>

                    <!-- Champ mot de passe -->
                    <div class="mb-3">
                        <label for="mdp" class="form-label">Mot de passe :</label>
                        <input type="password" name="mdp" class="form-control" id="mdp">
                        <?= validation_show_error('mdp') ?>
                    </div>

                    <!-- Bouton de soumission -->
                    <div class="d-flex justify-content-center">
                        <input type="submit" name="submit" value="Créer un nouveau compte" class="btn btn-success">
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
