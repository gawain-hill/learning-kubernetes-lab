
# Learning Kubernetes

## Summary

---
Project to expand my own knowledge of Kubernetes and other relevant technologies on multiple cloud platforms and bare metal.

Its heavily based on the excellent tutorial [Kubernetes the hard way](#credits) by Kelsey Hightower which I encourage you try.

## Getting started

---

### Setting up the tools

* [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) - *required*
* [Terraform](https://developer.hashicorp.com/terraform/downloads) - *required*
* [Terraform Docs](https://terraform-docs.io/user-guide/installation/) - *optional*
* [Pre-Commit](https://pre-commit.com/#install) - *optional*

### Create a GCP project

Create a GCP project via the CLI or Console this these labs are **not eligible for free tier** always make sure you have cleaned up your resources once your done so you don't get a surprise bill please have a read and understand [Google Cloud Billing documentation](https://cloud.google.com/billing/docs) so you know how to view and monitor your cloud spend.

### Configure Terraform GCP project

Once you have created a GCP project we need to update `main.tf` to use your GCP Project ID and the region and zones you want to create your resources in.

Before

```terraform
 provider "google" {
-  project = "{{YOUR GCP PROJECT}}"
   region  = "europe-west2"
   zone    = "europe-west2-a"
 }
```

After

```terraform
 provider "google" {
+  project = "my-lovely-project-12345"
   region  = "europe-west2"
   zone    = "europe-west2-a"
 }
```

*For documentation on the provider see [Google Provider Configuration Reference](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference)*

## Credits

---
**Title:** "Kubernetes the hard way"\
**Author:** Kelsey Hightower\
**Source:** <https://github.com/kelseyhightower/kubernetes-the-hard-way>\
**License:** [CC-BY-NC-SA-4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)\
**Usage:** initial terraform configuration mirrors the manual setup for the labs

## License

---
Content is copyright Gawain Hill, licensed under [CC-BY-NC-SA-4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
*When attributing please see the [CC best practice](https://wiki.creativecommons.org/wiki/Best_practices_for_attribution#This_is_a_great_attribution_for_an_image_you_modified_slightly)*
