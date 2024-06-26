<?php bb_get_header(); ?>

<div id="content">
    <!-- [ #content ] -->
    <div class="topcontent span-18">
        <div class="span-18 last stripetext"> <a href="<?php bb_uri(); ?>">
            <?php bb_option('name'); ?>
            </a> &raquo; <a href="<?php user_profile_link( $user_id ); ?>"><?php echo get_user_display_name( $user_id ); ?></a> &raquo;
            <?php _e('Profile') ?>
        </div>
    </div>
    <div class="clear span-18">
        <?php login_form(); ?>
        <?php if ( is_bb_profile() ) profile_menu(); ?>
    </div>
    <div class="span-18">
        <div id="profile" class="span-18">
            <p>
            <div class="vcard" role="main">
            
                <?php if ( $avatar = bb_get_avatar( $user->ID ) ) : ?>
                <div id="useravatar"><?php echo $avatar; ?></div>
                <br /><br />
                <?php unset($avatar); endif; ?>
                
                
                <h2 id="userlogin"><span class="fn"><?php echo get_user_display_name( $user->ID ); ?></span> <small>(<span class="nickname"><?php echo get_user_name( $user->ID ); ?></span>)</small></h2>
                <?php if ( $updated ) : ?>
                <div class="notice">
                    <p>
                        <?php _e('Profile updated'); ?>
                        . <a href="<?php profile_tab_link( $user_id, 'edit' ); ?>">
                        <?php _e('Edit again &raquo;'); ?>
                        </a></p>
                </div>
                <?php elseif ( $user_id == bb_get_current_user_info( 'id' ) ) : ?>
                <p>
                    <?php _e('This is how your profile appears to a logged in member.'); ?>
                    <?php if (bb_current_user_can( 'edit_user', $user->ID )) : ?>
                    <?php printf(__('You may <a href="%1$s">edit this information</a>.'), esc_attr( get_profile_tab_link( $user_id, 'edit' ) ) ); ?>
                    <?php endif; ?>
                </p>
                <?php if (bb_current_user_can( 'edit_favorites_of', $user->ID )) : ?>
                <p><?php printf(__('You can also <a href="%1$s">manage your favorites</a> and subscribe to your favorites&#8217; <a href="%2$s"><abbr title="Really Simple Syndication">RSS</abbr> feed</a>.'), esc_attr( get_favorites_link() ), esc_attr( get_favorites_rss_link() )); ?></p>
                <?php endif; ?>
                <?php endif; ?>
                <?php bb_profile_data(); ?>
            </div>
            <h3 id="useractivity">
                <?php _e('User Activity') ?>
            </h3>
            <div id="user-replies" class="user-recent">
                <h4>
                    <?php _e('Recent Replies'); ?>
                </h4>
                <?php if ( $posts ) : ?>
                <ol>
                    <?php foreach ($posts as $bb_post) : $topic = get_topic( $bb_post->topic_id ) ?>
                    <li<?php alt_class('replies'); ?>> <a href="<?php topic_link(); ?>">
                        <?php topic_title(); ?>
                        </a> -
                        <?php if ( $user->ID == bb_get_current_user_info( 'id' ) ) printf(__('You last replied: %s ago'), bb_get_post_time()); else printf(__('User last replied: %s ago'), bb_get_post_time()); ?>
                        | <span class="freshness">
                        <?php
		if ( bb_get_post_time( 'timestamp' ) < get_topic_time( 'timestamp' ) )
			printf(__('Most recent reply: %s ago'), get_topic_time());
		else
			_e('No replies since');
	?>
                        </span> </li>
                    <?php endforeach; ?>
                </ol>
                <?php else : if ( $page ) : ?>
                <p>
                    <?php _e('No more replies.') ?>
                </p>
                <?php else : ?>
                <p>
                    <?php _e('No replies yet.') ?>
                </p>
                <?php endif; endif; ?>
            </div>
            <div id="user-threads" class="user-recent">
                <h4>
                    <?php _e('Topics Started') ?>
                </h4>
                <?php if ( $topics ) : ?>
                <ol>
                    <?php foreach ($topics as $topic) : ?>
                    <li<?php alt_class('topics'); ?>> <a href="<?php topic_link(); ?>">
                        <?php topic_title(); ?>
                        </a> - <?php printf(__('Started: %s ago'), get_topic_start_time()); ?> | <span class="freshness">
                        <?php
		if ( get_topic_start_time( 'timestamp' ) < get_topic_time( 'timestamp' ) )
			printf(__('Most recent reply: %s ago'), get_topic_time());
		else
			_e('No replies.');
	?>
                        </span> </li>
                    <?php endforeach; ?>
                </ol>
                <?php else : if ( $page ) : ?>
                <p>
                    <?php _e('No more topics posted.') ?>
                </p>
                <?php else : ?>
                <p>
                    <?php _e('No topics posted yet.') ?>
                </p>
                <?php endif; endif;?>
            </div>
            <?php profile_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
            </p>
        </div>
    </div>
</div>
<?php bb_get_footer(); ?>
