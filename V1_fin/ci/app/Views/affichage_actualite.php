r<h1><?php echo $titre;?></h1><br />
<?php
    if (isset($news)){
    echo $news->idt_Actualite_act;
    echo(" -- ");
    echo $news->act_titre ;
    }
    else {
    echo ("Pas d'actualité !");
    }
?>