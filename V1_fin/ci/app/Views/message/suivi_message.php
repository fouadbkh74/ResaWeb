<br> <br> <br> <br> <br> <br> <br> <br> 


<div class="container"> <div class="row justify-content-center"> 
    <div class="col-12 col-md-8 col-lg-6"> 
        <div class="card shadow-lg p-4"> 
            <div class="card-body"> 
                <h1 class="text-center">

                    <?php echo $titre;?></h1><br/> 
                    <?php if (isset($donne)) { 
                        echo "<p><strong>Email :</strong> " . $donne->msg_email . "</p>"; 

                        echo "<p><strong>Contenu du Message :</strong> " . $donne->msg_contenue . "</p>"; 

                        echo "<p><strong>Date d'envoi :</strong> " . $donne->msg_date_envoie . "</p>"; 

    if (!empty($donne->msg_repense)) { echo "<p><strong>Réponse :</strong> " . $donne->msg_repense . "</p>"; } 
    else { echo "<p><strong>Réponse :</strong> Pas encore de réponse</p>"; } } ?>
               </div> 
            </div> 
        </div> 
    </div>
</div> 
 <br> <br> <br> <br> <br> <br>

     