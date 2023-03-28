
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
-   project = "{{YOUR GCP PROJECT}}"
    region  = "europe-west2"
    zone    = "europe-west2-a"
  }
```

After

```terraform
  provider "google" {
+   project = "my-lovely-project-12345"
    region  = "europe-west2"
    zone    = "europe-west2-a"
  }
```

*For documentation on the provider see [Google Provider Configuration Reference](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference)*

## Modifications to the original "Kubernetes the hard way infrastructure"

---

**Change:** Use a non-default service account for controller and worker instances \
**Reason:** Using the default service account is against best practice

```terraform
+ resource "google_service_account" "kubernetes_node" {
+   account_id   = "kubernetes-node"
+   display_name = "Kubernetes Node"
+ }
 
  resource "google_compute_instance" "kubernetes_controller" {
    ...
    service_account {
+     email = google_service_account.kubernetes_node.email
      ...
    }
  }
  
  resource "google_compute_instance" "kubernetes_worker" {
    ...
    service_account {
+     email = google_service_account.kubernetes_node.email
      ...
    }
  }
```

*For best practice guidance on service accounts see [Best practices for using service accounts](https://cloud.google.com/iam/docs/best-practices-service-accounts#development)*

---
**Change:** Disallow ip forwarding for controller and worker instances \
**Reason:** Disabling ip forwarding ensures the instance can only receive packets addressed to the instance and can only send packets with a source address of the instance.

```terraform
  resource "google_compute_instance" "kubernetes_controller" {
    ...
-   can_ip_forward = true
  }
  
  resource "google_compute_instance" "kubernetes_worker" {
    ...
-   can_ip_forward = true
  }
```

*For more information see [TF Sec - no ip forwarding](https://aquasecurity.github.io/tfsec/v1.28.1/checks/google/compute/no-ip-forwarding/)*

---

**Change:** Remove public IP from controller and worker instances \
**Reason:** Instances should not be publicly exposed to the internet

```terraform
  resource "google_compute_instance" "kubernetes_controller" {
    network_interface {
-     access_config {}
      ...
    }
    ...
  }

  resource "google_compute_instance" "kubernetes_worker" {
    network_interface {
-     access_config {}
      ...
    }
    ...
  }
```

*For more information see [TF Sec - no public ip](https://aquasecurity.github.io/tfsec/v1.28.1/checks/google/compute/no-public-ip/)*

---

**Change:** Disable project-wide SSH keys  \
**Reason:** If any one project wide key pair is compromised all instances would be compromised

```terraform
  resource "google_compute_instance" "kubernetes_controller" {
    metadata = {
+     block-project-ssh-keys = true
      ...
    }
    ...
  }
  
  resource "google_compute_instance" "kubernetes_worker" {
    metadata = {
+     block-project-ssh-keys = true
      ...
    }
    ...
  }
```

*For more information see [TF Sec - no project wide ssh keys](https://aquasecurity.github.io/tfsec/v1.28.1/checks/google/compute/no-project-wide-ssh-keys/)*

---

**Change:** Enable VTPM and integrity monitoring\
**Reason:** Prevent unwanted modification of system state such as malware

```terraform
resource "google_compute_instance" "kubernetes_controller" {
  ...
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }
}

resource "google_compute_instance" "kubernetes_worker" {
  ...
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }
}
```

*For more information see [TF Sec - Instances should have Shielded VM integrity monitoring enabled](https://aquasecurity.github.io/tfsec/v1.28.1/checks/google/compute/enable-shielded-vm-im/), [TF Sec - Enable shielded vm vtpm](https://aquasecurity.github.io/tfsec/v1.28.1/checks/google/compute/enable-shielded-vm-vtpm/), [Google Virtual Trusted Platform Module for Shielded VMs: security in plaintext](https://cloud.google.com/blog/products/identity-security/virtual-trusted-platform-module-for-shielded-vms-security-in-plaintext)*

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
