SELECT *
    FROM wp_posts
    WHERE id IN (SELECT post_id 
        FROM wp_postmeta 
        WHERE post_id IN (SELECT ID 
            FROM wp_posts 
            WHERE post_type = 'page')
        AND meta_key = '_wp_page_template'
        AND meta_value = 'theme.php');
