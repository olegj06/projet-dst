<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

 #$siteUrl = getenv('WORDPRESS_SITE_URL');
 #$homeUrl = getenv('WORDPRESS_HOME_URL');
 $dbUser = getenv('WORDPRESS_DB_USER');
 $dbPassword = getenv('WORDPRESS_DB_PASSWORD');
 $dbHost = getenv('WORDPRESS_DB_HOST');
 $dbName = getenv('WORDPRESS_DB_NAME');
 
 // ** MySQL settings - You can get this info from your web host ** //
 /** The name of the database for WordPress */
 define('DB_NAME', $dbName);
 
 /** MySQL database username */
 define('DB_USER', $dbUser);
 
 /** MySQL database password */
 define('DB_PASSWORD', $dbPassword);
 
 /** MySQL hostname */
 define('DB_HOST', $dbHost);
 
 /** Database Charset to use in creating database tables. */
 define('DB_CHARSET', 'utf8mb4');
 
 /** The Database Collate type. Don't change this if in doubt. */
 define('DB_COLLATE', '');
 
 #define('WP_HOME', $homeUrl);
 #define('WP_SITEURL',$siteUrl); 
 

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '<CThU@D}P&K1;1q2kdOvo_-!4|..9LS2lFCh|_)aXE7WZL~ZIO@2(O{{YM,:t<|b' );
define( 'SECURE_AUTH_KEY',  '4nm{UL ?p3Su+b[0|$0P>?!Vh}g]wn3bs#&mb+)*;`hk?xMI{hGWT*#.`>!b[x|)');
define( 'LOGGED_IN_KEY',    'sLJ{I7{AB23x=V)g8#3+;9frC|I|&1x7J6q5409UD$t;d~f>IffyU{f.aEBU+Ts:');
define( 'NONCE_KEY',        'gs5XSm|EZT-kkDw+-+d]<{c-Yred`d4vt|^[v0}4p8|5($a4D53*X%oI6f31;QT?');
define( 'AUTH_SALT',        '5sz.~E4=;T+>S&30~>` p`_<CkpR$]C8 )yAZqyC`eslm5qiPRz-#RM`|l@Rt3Sf' );
define( 'SECURE_AUTH_SALT', ';fxuUFo?FjkA:!DxYM{Q?v$OX<E8oq,N`~/iDK=,w@~TFg|#R86f{z/z,Vm?ppm:' );
define( 'LOGGED_IN_SALT',   '.o^,HYe.CeCBi{5G^-N$W[w;!~-O^/y2:O#Jdnx#t_Xra4pZz9Bng_2b(i)E{ 71' );
define( 'NONCE_SALT',       'wh3(kgRYr0grn2tG_bqpL|[qWy%rH}lDG/(~d=F,VW7/lczOdY<6QZ5ZqnPeWbT8' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';