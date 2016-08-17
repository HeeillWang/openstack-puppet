class keystone-dist-paste_ini($path = '/usr/share/keystone/keystone-dist-paste.ini'){
   file_line{'public_api':
      path   => $path,
      line   => "pipeline = sizelimit url_normalize request_id build_auth_context token_auth json_body ec2_extension user_crud_extension public_service",
      match  => "pipeline = sizelimit url_normalize request_id build_auth_context token_auth admin_token_auth json_body ec2_extension user_crud_extension public_service",
   }

   file_line{'admin_api':
      path   => $path,
      line   => "pipeline = sizelimit url_normalize request_id build_auth_context token_auth json_body ec2_extension s3_extension crud_extension admin_service",
      match  => "pipeline = sizelimit url_normalize request_id build_auth_context token_auth admin_token_auth json_body ec2_extension s3_extension crud_extension admin_service",
   }

   file_line{'api_v3':
      path   => $path,
      line   => "pipeline = sizelimit url_normalize request_id build_auth_context token_auth json_body ec2_extension_v3 s3_extension simple_cert_extension revoke_extension federation_extension oauth1_extension endpoint_filter_extension service_v3",
      match  => "pipeline = sizelimit url_normalize request_id build_auth_context token_auth admin_token_auth json_body ec2_extension_v3 s3_extension simple_cert_extension revoke_extension federation_extension oauth1_extension endpoint_filter_extension service_v3",
   }
}

include keystone-dist-paste_ini
