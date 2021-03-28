/*
## Create the SSL certificate with ACM.
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS" ## Use DNS validation. This is how to setup the validation records so that a person does not have to be involved in certificate installation and/or rotation.
  subject_alternative_names = [
    "app.${var.domain_name}",
    "api.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

## This creates a DNS record to validate the certificate.
resource "aws_route53_record" "cert_validation-0" {
  name     = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type     = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id  = var.hosted-zone-id
  records  = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl      = 60
}

## This step does the validation for the ssl certificate; associated with the kubernetes ingeress controller.
resource "aws_route53_record" "cert_validation-1" {
  name     = aws_acm_certificate.cert.domain_validation_options.1.resource_record_name
  type     = aws_acm_certificate.cert.domain_validation_options.1.resource_record_type
  zone_id  = var.hosted-zone-id
  records  = [aws_acm_certificate.cert.domain_validation_options.1.resource_record_value]
  ttl      = 60
}

## This step does the validation for the ssl certificate; associated with the kubernetes ingeress controller.
resource "aws_route53_record" "cert_validation-2" {
  name     = aws_acm_certificate.cert.domain_validation_options.2.resource_record_name
  type     = aws_acm_certificate.cert.domain_validation_options.2.resource_record_type
  zone_id  = var.hosted-zone-id
  records  = [aws_acm_certificate.cert.domain_validation_options.2.resource_record_value]
  ttl      = 60
}

## This step does the validation for the ssl certificate; associated with the kubernetes ingeress controller.
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation-0.fqdn,
    aws_route53_record.cert_validation-1.fqdn,
    aws_route53_record.cert_validation-2.fqdn
  ]
}
*/