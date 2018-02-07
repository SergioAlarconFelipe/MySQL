SELECT
	datos.ID
	, mail.meta_value as 'Email'
	, nombre.meta_value as 'Nombre'
	, apellidos.meta_value as 'Apellidos'
	, direccion1.meta_value as 'Direccion 1'
	, direccion2.meta_value as 'Direccion 2'
	, cp.meta_value as 'CP'
	, provincia.meta_value as 'Provincia'
	, localidad.meta_value as 'Localidad'
	, fechapago.meta_value as 'Fecha pago'
	, datos.post_excerpt as 'Notas'
	
FROM 
	wp_posts datos
	inner join wp_postmeta mail on ( mail.post_id = datos.ID and mail.meta_key = '_billing_email' )
	inner join wp_postmeta nombre on ( nombre.post_id = datos.ID and nombre.meta_key = '_billing_first_name' )
	inner join wp_postmeta apellidos on ( apellidos.post_id = datos.ID and apellidos.meta_key = '_billing_last_name' )
	inner join wp_postmeta direccion1 on ( direccion1.post_id = datos.ID and direccion1.meta_key = '_billing_address_1' )
	inner join wp_postmeta direccion2 on ( direccion2.post_id = datos.ID and direccion2.meta_key = '_billing_address_2' )
	inner join wp_postmeta cp on ( cp.post_id = datos.ID and cp.meta_key = '_billing_postcode' )
	inner join wp_postmeta provincia on ( provincia.post_id = datos.ID and provincia.meta_key = '_billing_state' )
	inner join wp_postmeta localidad on ( localidad.post_id = datos.ID and localidad.meta_key = '_billing_city' )
	inner join wp_postmeta fechapago on ( fechapago.post_id = datos.ID and fechapago.meta_key = '_paid_date' )
	
WHERE
	datos.ID IN	(	SELECT
						pedidos.ID

					FROM
						wp_posts pedidos
						inner join wp_woocommerce_order_items pedidos_items on ( pedidos.ID = pedidos_items.order_id and pedidos_items.order_item_type = 'line_item' )
						inner join wp_woocommerce_order_itemmeta pedidos_itemsmeta_product on ( pedidos_items.order_item_id = pedidos_itemsmeta_product.order_item_id 
																								and pedidos_itemsmeta_product.meta_key = '_product_id'
																								and pedidos_itemsmeta_product.meta_value = '" . $product_id . "' )
						inner join wp_woocommerce_order_itemmeta pedidos_itemsmeta_status on ( 	pedidos_items.order_item_id = pedidos_itemsmeta_status.order_item_id 
																								and pedidos_itemsmeta_status.meta_key = '_subscription_status'
																								and pedidos_itemsmeta_status.meta_value != 'trash' )

					WHERE
						pedidos.post_type = 'shop_order'
						and DATE( pedidos.post_date_gmt ) between DATE_SUB( NOW(), INTERVAL ( 2 * 3.5 ) MONTH ) and NOW()
						and pedidos.post_parent = 0

					UNION

					SELECT
						pedidos.ID

					FROM
						wp_posts pedidos
						inner join wp_woocommerce_order_items pedidos_items on ( pedidos.ID = pedidos_items.order_id and pedidos_items.order_item_type = 'line_item' )
						inner join wp_woocommerce_order_itemmeta pedidos_itemsmeta_product on ( pedidos_items.order_item_id = pedidos_itemsmeta_product.order_item_id 
																								and pedidos_itemsmeta_product.meta_key = '_product_id'
																								and pedidos_itemsmeta_product.meta_value = '" . $product_id . "' )

						left join wp_woocommerce_order_itemmeta pedidos_itemsmeta_status on ( 	pedidos_items.order_item_id = pedidos_itemsmeta_status.order_item_id 
																								and pedidos_itemsmeta_status.meta_key = '_subscription_status'
																								and pedidos_itemsmeta_status.meta_value != 'trash' )

					WHERE
						pedidos.post_type = 'shop_order'
						and DATE( pedidos.post_date_gmt ) between DATE_SUB( NOW(), INTERVAL ( 2 * 3.5 ) MONTH ) and NOW()
						and pedidos.post_parent != 0
					)
