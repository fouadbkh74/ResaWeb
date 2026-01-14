<h1><?php echo $titre; ?></h1><br />

<?php
if (!empty($news) && is_array($news)) {
    echo '<table class="table">
            <thead>
              <tr>
                <th scope="col">Actualités</th>
                <th scope="col">Auteur</th>
                <th scope="col">Texte</th>
                <th scope="col">Date de Publication</th>
              </tr>
            </thead>
            <tbody>';

    
    foreach ($news as $item) {
        echo '<tr>
                <td>' . $item["act_titre"] . '</td>
                <td>' . $item["cpt_pseudo"] . '</td>
                <td>' . $item["act_texte"] . '</td>
                <td>' . $item["act_date_pub"] . '</td>
              </tr>';
      
    }

    echo '</tbody></table>';
} else {
    echo "Aucune actualité pour l'instant !";
}
?>
