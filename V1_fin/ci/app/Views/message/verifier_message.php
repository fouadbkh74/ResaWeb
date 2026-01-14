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
                    <!-- Affichage des erreurs -->
                    <?= session()->getFlashdata('error') ?>
                    
                    <h1 class="text-center mb-4">Vérification du Code de Message</h1>

                    <?php
                        // Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
                        echo form_open('/message/verifier'); 
                    ?>

                    <?= csrf_field() ?>
                    <div class="mb-3">
                        <label for="code" class="form-label">Code de Message :</label>
                        <input type="text" name="code" id="code" class="form-control">
                        <?= validation_show_error('code') ?>
                    </div>
                    
                    <div class="d-flex justify-content-center">
                        <input type="submit" name="submit" value="Vérifier" class="btn btn-success">
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
<br>
<br>
<br>
