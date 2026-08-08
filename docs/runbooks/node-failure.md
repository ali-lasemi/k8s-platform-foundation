# Node Failure Runbook

## Symptoms

Use this runbook when:

- a node reports `NotReady`;
- workloads stop scheduling on a node;
- kubelet becomes unavailable;
- node pressure conditions appear;
- a worker becomes unreachable.

## Initial assessment

    kubectl get nodes -o wide

    kubectl describe node NODE_NAME

    kubectl get pods --all-namespaces \
      --field-selector spec.nodeName=NODE_NAME \
      -o wide

Check node conditions for:

- Ready;
- MemoryPressure;
- DiskPressure;
- PIDPressure;
- NetworkUnavailable.

## Protect scheduling

If the node is unstable but reachable:

    kubectl cordon NODE_NAME

Confirm:

    kubectl get nodes

## Investigate the host

On the affected node:

    sudo systemctl status k3s-agent

For a server node:

    sudo systemctl status k3s

Review recent logs:

    sudo journalctl -u k3s-agent -n 200 --no-pager

or:

    sudo journalctl -u k3s -n 200 --no-pager

Check capacity:

    df -h

    free -h

    uptime

## Drain a worker

Use the repository operation:

    ./operations/nodes/drain-node.sh NODE_NAME

Before draining, confirm disruption budgets and remaining cluster capacity.

## Restore the node

After correcting the host-level problem:

    kubectl get node NODE_NAME

    kubectl uncordon NODE_NAME

Validate workloads:

    kubectl get pods --all-namespaces -o wide

## Remove an unrecoverable worker

Only remove a worker after confirming it cannot safely return.

Use:

    ./operations/nodes/remove-worker.sh NODE_NAME

Do not use worker-removal procedures for a failed control-plane node without
reviewing the control-plane recovery procedure.

## Recovery criteria

Recovery is complete when:

- the expected nodes are Ready;
- workloads are rescheduled;
- no unexpected Pending pods remain;
- disruption budgets are healthy;
- platform health validation passes.
