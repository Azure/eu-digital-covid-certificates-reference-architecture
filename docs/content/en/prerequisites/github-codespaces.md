---
title: "GitHub Codespaces"
linkTitle: "GitHub Codespaces"
weight: 40
description: >
    Prerequisites necessary for deployment using GitHub Codespaces
---

This repository includes configuration for a DevContainer, allowing for repeatable and reliable usage in GitHub Codespaces or using [VS Code DevContainer]({{< relref "devcontainer" >}}).

This document describes it's use within a GitHub Codespaces. For other options, see [here]({{< relref "." >}}).

### Prepare GutHub Orginsation

To use Codespaces, you must [enable codespaces for your organization](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/enabling-codespaces-for-your-organization). Please follow the GitHub documentation, if Codespaces has not already been enabled.

### Fork the respository and open in Codespaces

Navigate to the [Reference Architecture GitHub Repository](https://github.com/Azure/eu-digital-covid-certificates-reference-architecture), and choose the "Fork" button from the upper right hand side of the page & choose the approperiate organisation.

Once the fork has been created - Choose the green "Code" button at the upper left of the page, select the CodeSpaces tab, select "New Codespace" and finally, select the machine type. We recommend the smallest machine type, that is the 2 core & 4GB RAM option.

GitHub will take several minutes to build the Codespace, once complete, proceed to the section below.

### Open a Terminal within Codespaces

To open a Terminal within the Codespace, press `Ctrl+Shift+P` (`Cmd+Shift+P` on OSX), and begin to type "Terminal". Choose the "Terminal: Create New Terminal" option and press return.


Read about [manual deployment]({{< relref "manual.md" >}}) in the next section.
