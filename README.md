# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform Static Website Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-static-site/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-static-site.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-static-site.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-static-site/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
This folder contains the necessary resources to deploy a static site. The module creates a cloud distribution, an S3 bucket to host the static web, and an S3 bucket for logs.

### ✨ Features



### 🔗 External Modules
| Name | Version |
|------|------:|
| [terraform-aws-modules/cloudfront/aws](https://github.com/terraform-aws-modules/cloudfront-aws) | 5.0.0 |
| [terraform-aws-modules/lambda/aws](https://github.com/terraform-aws-modules/lambda-aws) | 8.0.1 |
| [terraform-aws-modules/s3-bucket/aws](https://github.com/terraform-aws-modules/s3-bucket-aws) | 5.2.0 |



## 🚀 Quick Start
```hcl
static_site_parameters = {
  "exsimple" = {
    acm_certificate_arn   = data.aws_acm_certificate.this.arn
    custom_error_response = local.custom_error_response
    # enable_dashboard      = true # Default: false
    dns_records = {
      "" = {
        zone_name    = local.zone_public
        private_zone = false
      }
      # Para Generar un registro en la RAIZ de la Zona DNS
      # Utilizar como key _null_ 
      # "_null_" = {
      #   zone_name    = local.zone_public
      #   private_zone = false
      # } # Esto genera por Ej. https://example.com
      # Para generar mismo record en otra zona
      # "_null_-alternative" = {
      #   zone_name    = local.zone_public2
      #   private_zone = false
      #   record_name  = "_null_"
      # }
    }
  }
  "exlambda" = {
    acm_certificate_arn   = data.aws_acm_certificate.this.arn
    custom_error_response = local.custom_error_response
    dns_records = {
      "" = {
        zone_name    = local.zone_public
        private_zone = false
      }
    }
    lambdas = {
      "authentication" = {}
    }
    default_cache_behavior = {
      lambda_function_association = {
        "viewer-request" = {
          lambda_name  = "authentication"
          include_body = false
        }
      }
    }
  }
}
```


## 🔧 Additional Features Usage










---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la
- 🐛 **Issues**: [GitHub Issues](https://github.com/gocloudLa/issues)

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 