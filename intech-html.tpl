<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
{{- if . }}
    <style>
      :root {
        --gris-fonce: #262626;
        --gris-clair: #d8d8d8;
        --orange-clair: #f18e00;
        --orange-fonce: #b35e0a;
        --bg: #f4f4f5;
        --card: #ffffff;
        --text: #262626;
        --muted: #6b6b6e;
        --border: #ececee;
        --radius: 14px;
        --shadow: 0 1px 3px rgba(38, 38, 38, .07), 0 10px 30px rgba(38, 38, 38, .06);
      }
      * { box-sizing: border-box; }
      html { -webkit-text-size-adjust: 100%; }
      body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background: var(--bg);
        color: var(--text);
        line-height: 1.5;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
      }
      .page {
        max-width: 1180px;
        margin: 0 auto;
        padding: 44px 24px 72px;
      }

      /* ---- Header ---- */
      .report-header {
        position: relative;
        display: flex;
        align-items: center;
        gap: 28px;
        background: var(--card);
        border-radius: var(--radius);
        padding: 30px 34px;
        margin-bottom: 26px;
        box-shadow: var(--shadow);
        overflow: hidden;
      }
      .report-header::before {
        content: "";
        position: absolute;
        top: 0; left: 0; right: 0;
        height: 5px;
        background: linear-gradient(90deg, var(--orange-clair), var(--orange-fonce));
      }
      .logo {
        height: 60px;
        width: auto;
        flex-shrink: 0;
      }
      .report-titles {
        display: flex;
        flex-direction: column;
        gap: 3px;
        min-width: 0;
        padding-left: 28px;
        border-left: 1px solid var(--border);
      }
      .report-titles h1 {
        margin: 0;
        font-size: 1.5rem;
        font-weight: 700;
        letter-spacing: -.015em;
        color: var(--gris-fonce);
      }
      .report-titles .target {
        margin: 0;
        font-size: .92rem;
        font-weight: 600;
        color: var(--orange-fonce);
        word-break: break-all;
      }
      .report-titles .timestamp {
        margin: 2px 0 0;
        font-size: .78rem;
        color: var(--muted);
      }

      /* ---- Results card ---- */
      .results {
        background: var(--card);
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        overflow: hidden;
      }
      .table-scroll { overflow-x: auto; }
      table {
        width: 100%;
        border-collapse: collapse;
        font-size: .85rem;
      }

      .group-header th {
        background: var(--gris-fonce);
        color: #fff;
        font-size: .8rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: .09em;
        text-align: left;
        padding: 15px 20px;
      }
      .sub-header th {
        background: #f3f3f4;
        color: var(--gris-fonce);
        font-size: .7rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: .06em;
        text-align: left;
        padding: 11px 18px;
        border-top: 1px solid var(--border);
        border-bottom: 1px solid var(--border);
      }
      /* "No X found" notice rows (bare <tr> with a single <th>) */
      tr:not([class]) th {
        background: #fbfbfc;
        color: var(--muted);
        font-weight: 600;
        font-size: .82rem;
        text-align: center;
        padding: 16px 18px;
        border-bottom: 1px solid var(--border);
      }

      td {
        padding: 12px 18px;
        border-bottom: 1px solid var(--border);
        vertical-align: top;
      }
      tr[class*="severity-"]:hover td {
        background: rgba(241, 142, 0, .06);
      }
      table tr td:first-of-type {
        font-weight: 600;
        color: var(--gris-fonce);
      }
      .pkg-version { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }

      /* colored severity rail on the first cell */
      .severity-LOW      td:first-of-type { box-shadow: inset 3px 0 0 #3fa34d; }
      .severity-MEDIUM   td:first-of-type { box-shadow: inset 3px 0 0 #d8a200; }
      .severity-HIGH     td:first-of-type { box-shadow: inset 3px 0 0 var(--orange-clair); }
      .severity-CRITICAL td:first-of-type { box-shadow: inset 3px 0 0 #d92020; }
      .severity-UNKNOWN  td:first-of-type { box-shadow: inset 3px 0 0 #8a8a8e; }

      /* ---- Severity badge ---- */
      .severity { text-align: center; }
      .badge {
        display: inline-block;
        min-width: 82px;
        padding: 4px 12px;
        border-radius: 999px;
        font-size: .68rem;
        font-weight: 700;
        letter-spacing: .05em;
        text-transform: uppercase;
        color: #fff;
        white-space: nowrap;
      }
      .severity-LOW      .badge { background: #3fa34d; }
      .severity-MEDIUM   .badge { background: #d8a200; }
      .severity-HIGH     .badge { background: var(--orange-clair); }
      .severity-CRITICAL .badge { background: #d92020; }
      .severity-UNKNOWN  .badge { background: #8a8a8e; }

      /* ---- Links ---- */
      .links a,
      .link a {
        color: var(--orange-fonce);
        text-decoration: none;
        word-break: break-all;
      }
      .links a:hover,
      .link a:hover {
        color: var(--orange-clair);
        text-decoration: underline;
      }
      .links a,
      .links[data-more-links=on] a {
        display: block;
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
        max-width: 20vw;
      }
      .links[data-more-links=off] a:nth-of-type(1n+5) {
        display: none;
      }
      a.toggle-more-links {
        cursor: pointer;
        display: inline-block;
        margin-top: 4px;
        color: var(--gris-fonce);
        font-weight: 700;
        font-size: .76rem;
      }

      /* ---- Empty state ---- */
      .empty-state {
        padding: 64px 24px;
        text-align: center;
        color: var(--muted);
        font-size: .98rem;
      }

      @media (max-width: 600px) {
        .report-header { flex-direction: column; align-items: flex-start; gap: 18px; }
        .report-titles { padding-left: 0; border-left: 0; }
      }
    </style>
    <title>{{- escapeXML ( index . 0 ).Target }} - Trivy Report - {{ now }} </title>
    <script>
      window.onload = function() {
        document.querySelectorAll('td.links').forEach(function(linkCell) {
          var links = [].concat.apply([], linkCell.querySelectorAll('a'));
          [].sort.apply(links, function(a, b) {
            return a.href > b.href ? 1 : -1;
          });
          links.forEach(function(link, idx) {
            if (links.length > 3 && 3 === idx) {
              var toggleLink = document.createElement('a');
              toggleLink.innerText = "Toggle more links";
              toggleLink.href = "#toggleMore";
              toggleLink.setAttribute("class", "toggle-more-links");
              linkCell.appendChild(toggleLink);
            }
            linkCell.appendChild(link);
          });
        });
        document.querySelectorAll('a.toggle-more-links').forEach(function(toggleLink) {
          toggleLink.onclick = function() {
            var expanded = toggleLink.parentElement.getAttribute("data-more-links");
            toggleLink.parentElement.setAttribute("data-more-links", "on" === expanded ? "off" : "on");
            return false;
          };
        });
      };
    </script>
  </head>
  <body>
    <div class="page">
      <header class="report-header">
        <img class="logo" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjU4IiBoZWlnaHQ9Ijk3IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB4bWw6c3BhY2U9InByZXNlcnZlIiBvdmVyZmxvdz0iaGlkZGVuIj48ZGVmcz48Y2xpcFBhdGggaWQ9ImNsaXAwIj48cmVjdCB4PSI3OSIgeT0iMTkwIiB3aWR0aD0iMjU2IiBoZWlnaHQ9Ijk2Ii8+PC9jbGlwUGF0aD48Y2xpcFBhdGggaWQ9ImNsaXAxIj48cmVjdCB4PSI3OSIgeT0iMTkwIiB3aWR0aD0iMjU2IiBoZWlnaHQ9Ijk2Ii8+PC9jbGlwUGF0aD48Y2xpcFBhdGggaWQ9ImNsaXAyIj48cmVjdCB4PSI3OSIgeT0iMTkwIiB3aWR0aD0iMjU2IiBoZWlnaHQ9Ijk2Ii8+PC9jbGlwUGF0aD48L2RlZnM+PGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTc4IC0xODkpIj48Zz48ZyBjbGlwLXBhdGg9InVybCgjY2xpcDApIj48ZyBjbGlwLXBhdGg9InVybCgjY2xpcDEpIj48ZyBjbGlwLXBhdGg9InVybCgjY2xpcDIpIj48cGF0aCBkPSJNMTM4LjY4MSAwIDEzOS42ODIgMCAxMzkuNjgyIDc0LjUxMzcgMTM4LjY4MSA3NC41MTM3WiIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNOTAuODY4MyAxNS42MDM3IDk2LjcwOTMgMTUuNjAzNyA5Ni43MDkzIDU2LjA3MyA5MC44NjgzIDU2LjA3MyA5MC44NjgzIDE1LjYwMzciIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTEwMy43MTggMzMuNTQzN0MxMDMuNzE4IDI4LjQ1MzcgMTA2LjcyMiAyNS43MDAxIDExMi4yMjkgMjUuNzAwMUwxMjAuMjQgMjUuNzAwMUMxMjUuNzQ3IDI1LjcwMDEgMTI4Ljc1MSAyOC40NTM3IDEyOC43NTEgMzMuNTQzN0wxMjguNzUxIDU2LjA3MyAxMjMuNjYxIDU2LjA3MyAxMjMuNjYxIDM0LjIxMTIgMTIzLjY2MSAzMi45NTk2IDEyMy42NjEgMzIuNzkyN0MxMjMuNDExIDMxLjcwOCAxMjIuMjQzIDMwLjk1NyAxMjAuMjQgMzAuOTU3TDExMi4yMjkgMzAuOTU3QzEwOS41NTkgMzAuOTU3IDEwOC43MjUgMzEuNzkxNCAxMDguNzI1IDM0LjIxMTJMMTA4LjcyNSA1Ni4xNTY1IDEwMy42MzUgNTYuMTU2NSAxMDMuNjM1IDMzLjU0MzciIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTE0OC42OTQgMTUuNjAzNyAxNzQuNTYxIDE1LjYwMzcgMTc0LjU2MSAxNy42ODk3IDE2Mi42MjggMTcuNjg5NyAxNjIuNjI4IDU2LjA3MyAxNjAuNTQyIDU2LjA3MyAxNjAuNTQyIDE3LjY4OTcgMTQ4LjY5NCAxNy42ODk3IDE0OC42OTQgMTUuNjAzNyIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNMTk1LjQyMSAzNC4zNzgxQzE5NS41MDUgMzMuOTYwOSAxOTUuNTA1IDMzLjYyNzEgMTk1LjUwNSAzMy4yMDk5IDE5NS4zMzggMjkuMzcxNiAxOTMuMDAxIDI3LjM2OSAxODguMDc4IDI3LjM2OUwxODEuOTA0IDI3LjM2OUMxNzYuMTQ2IDI3LjM2OSAxNzMuODkzIDI5LjIwNDcgMTczLjg5MyAzMy43OTRMMTczLjg5MyA0My43MjM2IDE5NS40MjEgMzQuMzc4MVpNMTcyLjE0MSAzNC4zNzgxQzE3Mi4xNDEgMjguNDUzNyAxNzQuNTYxIDI1Ljk1MDUgMTgwLjE1MSAyNS41MzMyIDE4MC41NjggMjUuNDQ5OCAxODAuOTg2IDI1LjQ0OTggMTgxLjQ4NiAyNS40NDk4TDE4OC45MTMgMjUuNTMzMkMxOTUuMDA0IDI1LjYxNjcgMTk3LjM0IDI4LjAzNjUgMTk3LjM0IDM0Ljc5NTNMMTk3LjM0IDM1LjYyOTcgMTczLjk3NyA0NS44OTMxIDE3NC4wNiA0Ny4yMjgyQzE3NC4zMSA1Mi42NTE5IDE3NS45NzkgNTQuNDA0MiAxODEuMTUzIDU0LjQwNDJMMTk3LjM0IDU0LjQwNDIgMTk3LjM0IDU2LjIzOTkgMTgxLjU3IDU2LjIzOTlDMTc0Ljg5NCA1Ni4yMzk5IDE3Mi4xNDEgNTMuNTY5OCAxNzIuMTQxIDQ3LjU2MTlMMTcyLjE0MSAzNC4zNzgxIiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0yMDMuNzY1IDMzLjg3NzRDMjAzLjc2NSAyOC4yODY4IDIwNi40MzUgMjUuNTMzMiAyMTEuOTQzIDI1LjUzMzJMMjIzLjc5MSAyNS41MzMyIDIyMy43OTEgMjcuMzY5IDIxMi4xOTMgMjcuMzY5QzIxMC4xMDcgMjcuMzY5IDIwOS4wMjIgMjcuNjE5MyAyMDguMTA0IDI4LjIwMzQgMjA2LjEwMiAyOS40NTUgMjA1LjYwMSAzMC43MDY2IDIwNS42MDEgMzMuNjI3MUwyMDUuNjAxIDQ3LjQ3ODVDMjA1LjYwMSA1MC4wNjUyIDIwNi4zNTIgNTEuNjUwNiAyMDcuNzcxIDUyLjkwMjIgMjA5LjAyMiA1My45ODcgMjEwLjEwNyA1NC4zMjA3IDIxMi45NDQgNTQuMzIwN0wyMjMuOTU4IDU0LjMyMDcgMjIzLjk1OCA1Ni4xNTY1IDIxMi44NjEgNTYuMTU2NUMyMTAuMjc0IDU2LjE1NjUgMjA5LjE4OSA1NS45MDYxIDIwNy45MzcgNTUuNDA1NSAyMDUuMSA1My45MDM1IDIwMy43NjUgNTEuNjUwNiAyMDMuNzY1IDQ3LjgxMjNMMjAzLjc2NSAzMy44Nzc0IiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0yMzAuMDUgMTUuNjAzNyAyMzEuODg1IDE1LjYwMzcgMjMxLjg4NSAyNS41MzMyIDI0NS4xNTMgMjUuNTMzMkMyNTIuNTc5IDI1LjUzMzIgMjU1LjI0OSAyOC4wMzY1IDI1NS4yNDkgMzQuNTQ1TDI1NS4yNDkgNTYuMTU2NSAyNTMuNDEzIDU2LjE1NjUgMjUzLjQxMyAzNC42Mjg0QzI1My40MTMgMjkuNDU1IDI1MS4yNDQgMjcuMzY5IDI0Ni4xNTQgMjcuMzY5TDIzMS44MDIgMjcuMzY5IDIzMS44MDIgNTYuMDczIDIyOS45NjYgNTYuMDczIDIyOS45NjYgMTUuNjAzNyIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNNDguNTYzMiA5LjAxMTczQzQ4LjIyOTUgOS4xNzg2MiA0Ny44OTU3IDkuNTEyMzkgNDcuNjQ1NCAxMC4wMTMgNDcuMzk1IDEwLjUxMzcgNDcuMTQ0NyAxMS4wOTc4IDQ2Ljk3NzggMTEuODQ4OCA0Ni44MTEgMTIuNTk5NyA0Ni42NDQxIDEzLjQzNDIgNDYuNTYwNiAxNC40MzU1IDQ2LjQ3NzIgMTUuNDM2OCA0Ni40NzcyIDE2LjYwNSA0Ni40NzcyIDE3Ljg1NjYgNDYuNTYwNiAyMC4yNzY0IDQ2LjU2MDYgMjMuMTEzNCA0Ni42NDQxIDI2LjAzMzkgNDYuNzI3NSAyOS4wMzc4IDQ2LjgxMSAzMi4yMDg2IDQ2LjgxMSAzNS40NjI4IDQ2Ljg5NDQgMzguNzE3MSA0Ni45Nzc4IDQxLjg4NzkgNDYuOTc3OCA0NC44OTE4IDQ3LjA2MTMgNDcuODk1NyA0Ny4wNjEzIDUwLjczMjcgNDcuMTQ0NyA1My4yMzYgNDcuMjI4MiA1NS41NzI0IDQ3LjM5NSA1Ny43NDE5IDQ3LjgxMjMgNTkuNDk0MSA0OC4xNDYgNjEuMzI5OSA0OC43MzAxIDYyLjc0ODQgNDkuMzE0MiA2My44MzMxIDQ5Ljk4MTggNjQuOTE3OSA1MC42NDkzIDY1LjU4NTQgNTEuNDgzNyA2NS44MzU3IDUyLjMxODEgNjYuMDg2MSA1My4xNTI1IDY1LjkxOTIgNTQuMDcwNCA2NS4yNTE2IDU0LjA3MDQgNjUuMjUxNiA1NC4xNTM5IDY1LjE2ODIgNTQuMTUzOSA2NS4xNjgyIDU0LjE1MzkgNjUuMTY4MiA1NC4yMzczIDY1LjA4NDcgNTQuMjM3MyA2NS4wODQ3IDU0LjIzNzMgNjUuMDg0NyA1NC4zMjA3IDY1LjAwMTMgNTQuMzIwNyA2NS4wMDEzIDU0LjMyMDcgNjUuMDAxMyA1NC40MDQyIDY0LjkxNzkgNTQuNDA0MiA2NC45MTc5IDU1LjMyMiA2NC4wODM1IDU2LjQwNjggNjMuMDgyMSA1Ny41NzUgNjIuMDgwOCA1OC43NDMyIDYxLjA3OTUgNTkuOTExMyA1OS45OTQ4IDYxLjE2MyA1OC45MSA2Mi40MTQ2IDU3LjgyNTMgNjMuNTgyOCA1Ni43NDA2IDY0LjY2NzUgNTUuNzM5MyA2NS43NTIzIDU0LjczNzkgNjYuODM3IDUzLjgyMDEgNjcuNzU0OSA1My4wNjkxIDY4LjY3MjggNTIuMzE4MSA2OS4yNTY4IDUxLjIzMzQgNjkuNjc0MSA0OS45ODE4IDcwLjA5MTMgNDguNzMwMSA3MC4yNTgxIDQ3LjMxMTYgNzAuMjU4MSA0NS44MDk3IDcwLjI1ODEgNDQuMzA3NyA2OS45MjQ0IDQyLjYzODkgNjkuNDIzNyA0MC45NyA2OC45MjMxIDM5LjMwMTIgNjguMTcyMSAzNy42MzIzIDY3LjI1NDIgMzYuMTMwNCA2Ni4zMzY0IDM0LjU0NSA2NS4yNTE2IDMyLjcwOTMgNjQgMzAuNzA2NiA2Mi44MzE4IDI4LjcwNCA2MS41ODAyIDI2LjYxOCA2MC4yNDUxIDI0LjQ0ODUgNTguOTkzNSAyMi4yNzkgNTcuNjU4NCAyMC4xOTMgNTYuNDkwMiAxOC4xMDY5IDU1LjIzODYgMTYuMTA0MyA1NC4xNTM5IDE0LjE4NTEgNTMuMTUyNSAxMi41MTYzIDUyLjY1MTkgMTEuNjgxOSA1Mi4yMzQ3IDExLjAxNDMgNTEuNzM0IDEwLjUxMzcgNTEuMzE2OCA5LjkyOTYgNTAuODk5NiA5LjUxMjM5IDUwLjQ4MjQgOS4yNjIwNiA1MC4wNjUyIDguOTI4MjkgNDkuNjQ4IDguNzYxNDEgNDkuMzE0MiA4Ljc2MTQxIDQ5LjE0NzMgOC43NjE0MSA0OC44MTM2IDguNzYxNDEgNDguNTYzMiA5LjAxMTczIiBmaWxsPSIjQjM1RDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0zNi44ODE0IDMuMTcwOEMzNi4yOTczIDIuODM3MDMgMzUuNjI5NyAyLjU4NjcgMzQuOTYyMiAyLjU4NjcgMzQuMjk0NyAyLjUwMzI2IDMzLjU0MzcgMi41ODY3IDMyLjc5MjcgMi45MjA0NyAzMi4wNDE3IDMuMTcwOCAzMS4yOTA3IDMuNTg4MDEgMzAuNDU2MyA0LjE3MjEgMjkuNjIxOSA0Ljc1NjE5IDI4Ljg3MDkgNS41MDcxNyAyNy45NTMxIDYuMzQxNTkgMjYuMjg0MiA4LjA5Mzg3IDI0LjM2NTEgMTAuMTc5OSAyMi4zNjI1IDEyLjM0OTQgMjAuMzU5OCAxNC41MTg5IDE4LjE5MDQgMTYuODU1MyAxNi4wMjA5IDE5LjEwODIgMTMuOTM0OCAyMS4zNjExIDExLjc2NTMgMjMuNjE0MSA5Ljg0NjE1IDI1Ljc4MzYgNy45MjY5OSAyNy44Njk2IDYuMDkxMjcgMjkuNzg4OCA0LjUwNTg3IDMxLjQ1NzYgMi45MjA0NyAzMy4xMjY1IDEuODM1NzIgMzQuOTYyMiAxLjA4NDc1IDM2Ljc5NzkgMC4zMzM3NjggMzguNjMzNiAwIDQwLjQ2OTQgMCA0Mi4zMDUxIDAuMDgzNDQyIDQ0LjE0MDggMC41MDA2NTIgNDUuODkzMSAxLjMzNTA3IDQ3LjU2MTkgMi4xNjk0OSA0OS4xNDczIDMuNDIxMTIgNTAuNjQ5MyA1LjAwNjUyIDUxLjgxNzUgNi41OTE5MiA1Mi45ODU3IDguNTExMDggNTQuNDA0MiAxMC41OTcxIDU1LjkwNjEgMTIuNjgzMiA1Ny40MDgxIDE0Ljg1MjcgNTguOTkzNSAxNy4xMDU2IDYwLjY2MjMgMTkuMzU4NSA2Mi4zMzEyIDIxLjYxMTUgNjQgMjMuNzgxIDY1LjUwMiAyNS45NTA1IDY3LjA4NzQgMjguMDM2NSA2OC41ODkzIDI5Ljc4ODggNjkuOTI0NCAzMS41NDExIDcxLjI1OTUgMzMuMjkzNCA3MS44NDM1IDM0Ljc5NTMgNzEuOTI3IDM2LjM4MDcgNzIuMDEwNCAzNy43MTU4IDcxLjQyNjMgMzguODg0IDcwLjM0MTYgNDAuMDUyMiA2OS4yNTY4IDQwLjk3IDY3LjU4OCA0MS41NTQxIDY1LjUwMiA0Mi4xMzgyIDYzLjMzMjUgNDIuNDcyIDYwLjc0NTggNDIuMzg4NSA1Ny43NDE5IDQyLjMwNTEgNTQuNzM3OSA0Mi4yMjE2IDUxLjIzMzQgNDIuMDU0OCA0Ny41NjE5IDQxLjk3MTMgNDMuODkwNSA0MS44MDQ0IDM5Ljg4NTMgNDEuNzIxIDM1Ljk2MzUgNDEuNjM3NiAzMi4wNDE3IDQxLjQ3MDcgMjguMTE5OSA0MS4zODcyIDI0LjQ0ODUgNDEuMzAzOCAyMC43NzcxIDQxLjEzNjkgMTcuMzU1OSA0MS4wNTM1IDE0LjQzNTUgNDEuMDUzNSAxMi45MzM1IDQwLjg4NjYgMTEuNTk4NCA0MC42MzYyIDEwLjQzMDIgNDAuMzg1OSA5LjE3ODYyIDQwLjEzNTYgOC4xNzczMSAzOS44MDE4IDcuMTc2MDEgMzkuNDY4MSA2LjI1ODE1IDM5LjA1MDggNS40MjM3MyAzOC41NTAyIDQuNzU2MTkgMzcuOTY2MSA0LjA4ODY2IDM3LjQ2NTUgMy41ODgwMSAzNi44ODE0IDMuMTcwOCIgZmlsbD0iI0YyOEMwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNOTAuOTUxOCA4MS4yNzI1QzkxLjIwMjEgODEuMjcyNSA5MS42MTkzIDgxLjE4OTEgOTIuMTE5OSA4MS4xMDU2IDkyLjYyMDYgODEuMDIyMiA5My4yODgxIDgxLjAyMjIgOTQuMTIyNiA4MS4wMjIyIDk0LjcwNjYgODEuMDIyMiA5NS4yOTA3IDgxLjEwNTYgOTUuODc0OCA4MS4xODkxIDk2LjQ1ODkgODEuMjcyNSA5Ny4wNDMgODEuNTIyOCA5Ny40NjAyIDgxLjc3MzEgOTcuOTYwOSA4Mi4xMDY5IDk4LjI5NDcgODIuNTI0MSA5OC42Mjg0IDgzLjAyNDggOTguOTYyMiA4My42MDg5IDk5LjA0NTYgODQuMjc2NCA5OS4wNDU2IDg1LjE5NDMgOTkuMDQ1NiA4NS45NDUyIDk4Ljk2MjIgODYuNjEyOCA5OC43MTE5IDg3LjE5NjkgOTguNDYxNSA4Ny42OTc1IDk4LjEyNzggODguMTE0NyA5Ny43OTQgODguNDQ4NSA5Ny4zNzY4IDg4Ljc4MjMgOTYuOTU5NiA4OC45NDkyIDk2LjQ1ODkgODkuMTE2IDk1Ljk1ODMgODkuMjgyOSA5NS40NTc2IDg5LjI4MjkgOTQuODczNSA4OS4yODI5IDk0LjYyMzIgODkuMjgyOSA5NC40NTYzIDg5LjI4MjkgOTQuMjA2IDg5LjI4MjkgOTMuOTU1NyA4OS4yODI5IDkzLjg3MjIgODkuMjgyOSA5My43ODg4IDg5LjE5OTVMOTMuNzg4OCA5My4wMzc4QzkzLjUzODUgOTMuMTIxMyA5My4yMDQ3IDkzLjEyMTMgOTMuMDM3OCA5My4xMjEzIDkyLjc4NzUgOTMuMTIxMyA5Mi42MjA2IDkzLjEyMTMgOTIuMzcwMyA5My4xMjEzIDkxLjk1MzEgOTMuMTIxMyA5MS41MzU5IDkzLjAzNzggOTAuOTUxOCA5Mi45NTQ0TDkwLjk1MTggODEuMjcyNVpNOTMuNzg4OCA4Ni45NDY1QzkzLjg3MjIgODYuOTQ2NSA5My45NTU3IDg2Ljk0NjUgOTQuMDM5MSA4Ny4wMyA5NC4yMDYgODcuMDMgOTQuMjg5NCA4Ny4wMyA5NC40NTYzIDg3LjAzIDk0Ljk1NyA4Ny4wMyA5NS4yOTA3IDg2Ljg2MzEgOTUuNjI0NSA4Ni42MTI4IDk1Ljk1ODMgODYuMzYyNSA5Ni4wNDE3IDg1Ljk0NTIgOTYuMDQxNyA4NS4zNjEyIDk2LjA0MTcgODUuMDI3NCA5NS45NTgzIDg0Ljc3NzEgOTUuODc0OCA4NC41MjY3IDk1Ljc5MTQgODQuMjc2NCA5NS42MjQ1IDg0LjEwOTUgOTUuNDU3NiA4My45NDI2IDk1LjI5MDcgODMuNzc1OCA5NS4xMjM5IDgzLjY5MjMgOTQuODczNSA4My42OTIzIDk0LjYyMzIgODMuNjA4OSA5NC40NTYzIDgzLjYwODkgOTQuMjA2IDgzLjYwODkgOTQuMTIyNiA4My42MDg5IDk0LjAzOTEgODMuNjA4OSA5My45NTU3IDgzLjYwODkgOTMuODcyMiA4My42MDg5IDkzLjc4ODggODMuNjA4OSA5My43MDU0IDgzLjYwODlMOTMuNzA1NCA4Ni45NDY1WiIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNOTkuNzEzMiA4OC45NDkyQzk5LjcxMzIgODguMjgxNiA5OS43OTY2IDg3LjYxNDEgOTkuOTYzNSA4Ny4xMTM0IDEwMC4xMyA4Ni41MjkzIDEwMC4zODEgODYuMTEyMSAxMDAuNzk4IDg1LjY5NDkgMTAxLjEzMiA4NS4yNzc3IDEwMS42MzIgODUuMDI3NCAxMDIuMTMzIDg0Ljc3NzEgMTAyLjYzNCA4NC41MjY3IDEwMy4zMDEgODQuNDQzMyAxMDMuOTY5IDg0LjQ0MzMgMTA0LjYzNiA4NC40NDMzIDEwNS4zMDQgODQuNTI2NyAxMDUuODA0IDg0Ljc3NzEgMTA2LjMwNSA4NS4wMjc0IDEwNi44MDYgODUuMjc3NyAxMDcuMTQgODUuNjk0OSAxMDcuNDczIDg2LjExMjEgMTA3LjgwNyA4Ni42MTI4IDEwNy45NzQgODcuMTEzNCAxMDguMTQxIDg3LjY5NzUgMTA4LjIyNCA4OC4yODE2IDEwOC4yMjQgODguOTQ5MiAxMDguMjI0IDg5LjYxNjcgMTA4LjE0MSA5MC4yMDA4IDEwNy45NzQgOTAuNzg0OSAxMDcuODA3IDkxLjM2OSAxMDcuNTU3IDkxLjc4NjIgMTA3LjE0IDkyLjIwMzQgMTA2LjgwNiA5Mi42MjA2IDEwNi4zMDUgOTIuODcwOSAxMDUuODA0IDkzLjEyMTMgMTA1LjMwNCA5My4zNzE2IDEwNC42MzYgOTMuNDU1IDEwMy45NjkgOTMuNDU1IDEwMy4zMDEgOTMuNDU1IDEwMi42MzQgOTMuMzcxNiAxMDIuMTMzIDkzLjEyMTMgMTAxLjYzMiA5Mi44NzA5IDEwMS4xMzIgOTIuNjIwNiAxMDAuNzk4IDkyLjIwMzQgMTAwLjQ2NCA5MS43ODYyIDEwMC4xMyA5MS4zNjkgOTkuOTYzNSA5MC43ODQ5IDk5Ljc5NjYgOTAuMjAwOCA5OS43MTMyIDg5LjYxNjcgOTkuNzEzMiA4OC45NDkyWk0xMDUuMzg3IDg4Ljk0OTJDMTA1LjM4NyA4OC4xOTgyIDEwNS4zMDQgODcuNjk3NSAxMDUuMDUzIDg3LjI4MDMgMTA0LjgwMyA4Ni44NjMxIDEwNC40NjkgODYuNjk2MiAxMDMuOTY5IDg2LjY5NjIgMTAzLjQ2OCA4Ni42OTYyIDEwMy4xMzQgODYuODYzMSAxMDIuODg0IDg3LjI4MDMgMTAyLjYzNCA4Ny42OTc1IDEwMi41NSA4OC4xOTgyIDEwMi41NSA4OC45NDkyIDEwMi41NSA4OS42MTY3IDEwMi42MzQgOTAuMjAwOCAxMDIuODg0IDkwLjUzNDYgMTAzLjEzNCA5MC45NTE4IDEwMy40NjggOTEuMTE4NiAxMDMuOTY5IDkxLjExODYgMTA0LjQ2OSA5MS4xMTg2IDEwNC44MDMgOTAuOTUxOCAxMDUuMDUzIDkwLjUzNDYgMTA1LjMwNCA5MC4yMDA4IDEwNS4zODcgODkuNzAwMSAxMDUuMzg3IDg4Ljk0OTJaIiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0xMTMuODE1IDg3Ljg2NDRDMTE0LjE0OSA4Ny45NDc5IDExNC40ODIgODguMDMxMyAxMTQuNzMzIDg4LjE5ODIgMTE0Ljk4MyA4OC4zNjUxIDExNS4yMzMgODguNDQ4NSAxMTUuNCA4OC42OTg4IDExNS41NjcgODguODY1NyAxMTUuNzM0IDg5LjExNiAxMTUuODE3IDg5LjQ0OTggMTE1LjkwMSA4OS43MDAxIDExNS45ODQgOTAuMTE3MyAxMTUuOTg0IDkwLjUzNDYgMTE1Ljk4NCA5MC45NTE4IDExNS45MDEgOTEuMzY5IDExNS43MzQgOTEuNzAyNyAxMTUuNTY3IDkyLjAzNjUgMTE1LjMxNyA5Mi4zNzAzIDExNC45ODMgOTIuNjIwNiAxMTQuNjQ5IDkyLjg3MDkgMTE0LjIzMiA5My4xMjEzIDExMy43MzEgOTMuMjg4MSAxMTMuMjMxIDkzLjQ1NSAxMTIuNjQ3IDkzLjUzODUgMTEyLjA2MyA5My41Mzg1IDExMS41NjIgOTMuNTM4NSAxMTEuMDYxIDkzLjUzODUgMTEwLjU2MSA5My40NTUgMTEwLjE0MyA5My4zNzE2IDEwOS42NDMgOTMuMjA0NyAxMDkuMTQyIDkzLjAzNzggMTA5LjIyNiA5Mi4yODY4IDEwOS4zOTIgOTEuNTM1OSAxMDkuNzI2IDkwLjc4NDkgMTEwLjA2IDkwLjk1MTggMTEwLjQ3NyA5MS4wMzUyIDExMC44MTEgOTEuMTE4NiAxMTEuMjI4IDkxLjIwMjEgMTExLjU2MiA5MS4yMDIxIDExMS45NzkgOTEuMjAyMSAxMTIuMTQ2IDkxLjIwMjEgMTEyLjIyOSA5MS4yMDIxIDExMi4zOTYgOTEuMjAyMSAxMTIuNTYzIDkxLjIwMjEgMTEyLjY0NyA5MS4yMDIxIDExMi44MTQgOTEuMTE4NiAxMTIuODk3IDkxLjExODYgMTEyLjk4IDkxLjAzNTIgMTEzLjA2NCA5MC45NTE4IDExMy4xNDcgOTAuODY4MyAxMTMuMTQ3IDkwLjc4NDkgMTEzLjE0NyA5MC43MDE0IDExMy4xNDcgOTAuNTM0NiAxMTMuMDY0IDkwLjQ1MTEgMTEyLjg5NyA5MC4zNjc3IDExMi43MyA5MC4yODQyIDExMi41NjMgOTAuMjAwOCAxMTIuMzk2IDkwLjIwMDhMMTExLjIyOCA4OS44NjdDMTEwLjY0NCA4OS43MDAxIDExMC4xNDMgODkuNDQ5OCAxMDkuNzI2IDg5LjAzMjYgMTA5LjMwOSA4OC42MTU0IDEwOS4xNDIgODguMTE0NyAxMDkuMTQyIDg3LjM2MzggMTA5LjE0MiA4Ni45NDY1IDEwOS4yMjYgODYuNTI5MyAxMDkuMzkyIDg2LjE5NTYgMTA5LjU1OSA4NS44NjE4IDEwOS44MSA4NS41MjggMTEwLjE0MyA4NS4yNzc3IDExMC40NzcgODUuMDI3NCAxMTAuODExIDg0Ljg2MDUgMTExLjMxMiA4NC42OTM2IDExMS43MjkgODQuNTI2NyAxMTIuMjI5IDg0LjUyNjcgMTEyLjczIDg0LjUyNjcgMTEzLjE0NyA4NC41MjY3IDExMy42NDggODQuNjEwMiAxMTQuMTQ5IDg0LjY5MzYgMTE0LjY0OSA4NC43NzcxIDExNS4xNSA4NC45NDM5IDExNS42NTEgODUuMTEwOCAxMTUuNjUxIDg1LjQ0NDYgMTE1LjU2NyA4NS44NjE4IDExNS40IDg2LjI3OSAxMTUuMzE3IDg2LjY5NjIgMTE1LjE1IDg3LjAzIDExNC45ODMgODcuMzYzOCAxMTQuNjQ5IDg3LjI4MDMgMTE0LjMxNiA4Ny4xMTM0IDExMy44OTggODcuMDMgMTEzLjQ4MSA4Ni45NDY1IDExMy4wNjQgODYuODYzMSAxMTIuNzMgODYuODYzMSAxMTIuMjI5IDg2Ljg2MzEgMTExLjk3OSA4Ny4wMyAxMTEuOTc5IDg3LjI4MDMgMTExLjk3OSA4Ny4zNjM4IDExMi4wNjMgODcuNTMwNiAxMTIuMTQ2IDg3LjUzMDYgMTEyLjIyOSA4Ny42MTQxIDExMi4zOTYgODcuNjE0MSAxMTIuNTYzIDg3LjY5NzVMMTEzLjgxNSA4Ny44NjQ0WiIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNMTE5LjIzOSA4Ni45NDY1IDExNi44MTkgODYuOTQ2NUMxMTYuNzM1IDg2LjY5NjIgMTE2LjczNSA4Ni41MjkzIDExNi43MzUgODYuMzYyNSAxMTYuNzM1IDg2LjE5NTYgMTE2LjczNSA4NS45NDUyIDExNi43MzUgODUuNzc4NCAxMTYuNzM1IDg1LjYxMTUgMTE2LjczNSA4NS40NDQ2IDExNi43MzUgODUuMTk0MyAxMTYuNzM1IDg1LjAyNzQgMTE2LjgxOSA4NC43NzcxIDExNi44MTkgODQuNjEwMkwxMjQuNTc5IDg0LjYxMDJDMTI0LjY2MiA4NC44NjA1IDEyNC42NjIgODUuMDI3NCAxMjQuNjYyIDg1LjE5NDMgMTI0LjY2MiA4NS4zNjEyIDEyNC42NjIgODUuNTI4IDEyNC42NjIgODUuNzc4NCAxMjQuNjYyIDg1Ljk0NTIgMTI0LjY2MiA4Ni4xMTIxIDEyNC42NjIgODYuMzYyNSAxMjQuNjYyIDg2LjUyOTMgMTI0LjU3OSA4Ni43Nzk3IDEyNC41NzkgODYuOTQ2NUwxMjIuMTU5IDg2Ljk0NjUgMTIyLjE1OSA5My4yMDQ3QzEyMS45MDkgOTMuMjg4MSAxMjEuNTc1IDkzLjI4ODEgMTIxLjQwOCA5My4yODgxIDEyMS4xNTggOTMuMjg4MSAxMjAuOTkxIDkzLjI4ODEgMTIwLjc0MSA5My4yODgxIDEyMC41NzQgOTMuMjg4MSAxMjAuMzIzIDkzLjI4ODEgMTIwLjA3MyA5My4yODgxIDExOS44MjMgOTMuMjg4MSAxMTkuNTcyIDkzLjIwNDcgMTE5LjMyMiA5My4yMDQ3TDExOS4zMjIgODYuOTQ2NVoiIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTIyNS4yOTMgODQuNDQzM0MyMjcuMzc5IDg0LjQ0MzMgMjI4LjQ2NCA4NS40NDQ2IDIyOC40NjQgODUuNDQ0NkwyMjcuODggODYuMzYyNUMyMjcuODggODYuMzYyNSAyMjYuODc5IDg1LjUyOCAyMjUuNDYgODUuNTI4IDIyMy40NTggODUuNTI4IDIyMi4yMDYgODcuMDMgMjIyLjIwNiA4OC44NjU3IDIyMi4yMDYgOTAuODY4MyAyMjMuNTQxIDkyLjI4NjggMjI1LjM3NyA5Mi4yODY4IDIyNi44NzkgOTIuMjg2OCAyMjcuNzk3IDkxLjIwMjEgMjI3Ljc5NyA5MS4yMDIxTDIyNy43OTcgODkuOTUwNSAyMjYuMzc4IDg5Ljk1MDUgMjI2LjM3OCA4OC44NjU3IDIyOC44ODEgODguODY1NyAyMjguODgxIDkzLjIwNDcgMjI3Ljc5NyA5My4yMDQ3IDIyNy43OTcgOTIuNzA0QzIyNy43OTcgOTIuNTM3MiAyMjcuNzk3IDkyLjM3MDMgMjI3Ljc5NyA5Mi4zNzAzIDIyNy43OTcgOTIuMzcwMyAyMjYuODc5IDkzLjQ1NSAyMjUuMTI2IDkzLjQ1NSAyMjIuNzkgOTMuNDU1IDIyMC44NzEgOTEuNjE5MyAyMjAuODcxIDg4Ljk0OTIgMjIwLjg3MSA4Ni40NDU5IDIyMi43OSA4NC40NDMzIDIyNS4yOTMgODQuNDQzM1oiIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTIzMC41NSA4Ny4xMTM0IDIzMS43MTggODcuMTEzNCAyMzEuNzE4IDg4LjE5ODJDMjMxLjcxOCA4OC40NDg1IDIzMS43MTggODguNjk4OCAyMzEuNzE4IDg4LjY5ODggMjMxLjk2OSA4Ny43ODEgMjMyLjcyIDg3LjExMzQgMjMzLjcyMSA4Ny4xMTM0IDIzMy44ODggODcuMTEzNCAyMzQuMDU1IDg3LjExMzQgMjM0LjA1NSA4Ny4xMTM0TDIzNC4wNTUgODguMjgxNkMyMzQuMDU1IDg4LjI4MTYgMjMzLjg4OCA4OC4yODE2IDIzMy43MjEgODguMjgxNiAyMzIuOTcgODguMjgxNiAyMzIuMzAyIDg4Ljc4MjMgMjMxLjk2OSA4OS43ODM2IDIzMS44ODUgOTAuMTE3MyAyMzEuODAyIDkwLjUzNDYgMjMxLjgwMiA5MC44NjgzTDIzMS44MDIgOTMuMzcxNiAyMzAuNjM0IDkzLjM3MTYgMjMwLjYzNCA4Ny4xMTM0WiIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNMjM4LjA2IDg2Ljk0NjVDMjM5Ljg5NiA4Ni45NDY1IDI0MS4zOTggODguMjgxNiAyNDEuMzk4IDkwLjIwMDggMjQxLjM5OCA5Mi4xMTk5IDIzOS44OTYgOTMuNDU1IDIzOC4wNiA5My40NTUgMjM2LjIyNCA5My40NTUgMjM0LjcyMiA5Mi4xMTk5IDIzNC43MjIgOTAuMjAwOCAyMzQuNjM5IDg4LjI4MTYgMjM2LjE0MSA4Ni45NDY1IDIzOC4wNiA4Ni45NDY1Wk0yMzguMDYgOTIuMzcwM0MyMzkuMjI4IDkyLjM3MDMgMjQwLjIyOSA5MS40NTI0IDI0MC4yMjkgOTAuMTE3MyAyNDAuMjI5IDg4Ljg2NTcgMjM5LjMxMiA4Ny45NDc5IDIzOC4wNiA4Ny45NDc5IDIzNi44OTIgODcuOTQ3OSAyMzUuODkxIDg4Ljg2NTcgMjM1Ljg5MSA5MC4xMTczIDIzNS44OTEgOTEuNDUyNCAyMzYuODkyIDkyLjM3MDMgMjM4LjA2IDkyLjM3MDNaIiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0yNDIuNzMzIDg3LjExMzQgMjQzLjkwMSA4Ny4xMTM0IDI0My45MDEgOTAuNzg0OUMyNDMuOTAxIDkxLjYxOTMgMjQ0LjA2OCA5Mi4zNzAzIDI0NS4wNjkgOTIuMzcwMyAyNDYuMzIxIDkyLjM3MDMgMjQ3LjA3MiA5MS4yODU1IDI0Ny4wNzIgOTAuMDMzOUwyNDcuMDcyIDg3LjExMzQgMjQ4LjI0IDg3LjExMzQgMjQ4LjI0IDkzLjI4ODEgMjQ3LjA3MiA5My4yODgxIDI0Ny4wNzIgOTIuNDUzN0MyNDcuMDcyIDkyLjIwMzQgMjQ3LjA3MiA5Mi4wMzY1IDI0Ny4wNzIgOTIuMDM2NSAyNDYuODIxIDkyLjYyMDYgMjQ1Ljk4NyA5My40NTUgMjQ0LjgxOSA5My40NTUgMjQzLjQgOTMuNDU1IDI0Mi43MzMgOTIuNzA0IDI0Mi43MzMgOTEuMDM1MkwyNDIuNzMzIDg3LjExMzRaIiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0yNTAuMTU5IDg3LjExMzQgMjUxLjI0NCA4Ny4xMTM0IDI1MS4yNDQgODcuNjE0MUMyNTEuMjQ0IDg3Ljg2NDQgMjUxLjI0NCA4OC4wMzEzIDI1MS4yNDQgODguMDMxMyAyNTEuMjQ0IDg4LjAzMTMgMjUxLjc0NCA4Ni44NjMxIDI1My4zMyA4Ni44NjMxIDI1NC45OTkgODYuODYzMSAyNTYuMDgzIDg4LjE5ODIgMjU2LjA4MyA5MC4xMTczIDI1Ni4wODMgOTIuMTE5OSAyNTQuOTE1IDkzLjM3MTYgMjUzLjI0NiA5My4zNzE2IDI1MS45MTEgOTMuMzcxNiAyNTEuMzI3IDkyLjM3MDMgMjUxLjMyNyA5Mi4zNzAzIDI1MS4zMjcgOTIuMzcwMyAyNTEuMzI3IDkyLjYyMDYgMjUxLjMyNyA5Mi44NzA5TDI1MS4zMjcgOTUuNjI0NSAyNTAuMTU5IDk1LjYyNDUgMjUwLjE1OSA4Ny4xMTM0Wk0yNTIuOTk2IDkyLjM3MDNDMjUzLjk5NyA5Mi4zNzAzIDI1NC43NDggOTEuNTM1OSAyNTQuNzQ4IDkwLjExNzMgMjU0Ljc0OCA4OC43ODIzIDI1My45OTcgODcuODY0NCAyNTIuOTk2IDg3Ljg2NDQgMjUyLjA3OCA4Ny44NjQ0IDI1MS4yNDQgODguNTMxOSAyNTEuMjQ0IDkwLjExNzMgMjUxLjI0NCA5MS4yODU1IDI1MS45MTEgOTIuMzcwMyAyNTIuOTk2IDkyLjM3MDNaIiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0xMjkuMDAxIDg0LjYxMDIgMTMwLjI1MyA4NC42MTAyIDEzMC4yNTMgOTIuMjAzNCAxMzQuMDkxIDkyLjIwMzQgMTM0LjA5MSA5My4yODgxIDEyOS4wMDEgOTMuMjg4MSAxMjkuMDAxIDg0LjYxMDJaIiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0xMzUuNTEgODQuNjEwMiAxMzYuNzYxIDg0LjYxMDIgMTM2Ljc2MSA5MC4yMDA4QzEzNi43NjEgOTEuNTM1OSAxMzcuNTk2IDkyLjI4NjggMTM4LjkzMSA5Mi4yODY4IDE0MC4yNjYgOTIuMjg2OCAxNDEuMSA5MS41MzU5IDE0MS4xIDkwLjIwMDhMMTQxLjEgODQuNjEwMiAxNDIuMzUyIDg0LjYxMDIgMTQyLjM1MiA5MC4yMDA4QzE0Mi4zNTIgOTIuMTE5OSAxNDAuOTM0IDkzLjQ1NSAxMzguOTMxIDkzLjQ1NSAxMzYuOTI4IDkzLjQ1NSAxMzUuNTEgOTIuMjAzNCAxMzUuNTEgOTAuMjAwOEwxMzUuNTEgODQuNjEwMloiIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTE0Ni42MDggODguNzgyMyAxNDQuMDIxIDg0LjYxMDIgMTQ1LjQzOSA4NC42MTAyIDE0Ni43NzQgODYuOTQ2NUMxNDcuMDI1IDg3LjQ0NzIgMTQ3LjM1OSA4Ny45NDc5IDE0Ny4zNTkgODcuOTQ3OSAxNDcuMzU5IDg3Ljk0NzkgMTQ3LjYwOSA4Ny4zNjM4IDE0Ny44NTkgODYuOTQ2NUwxNDkuMTk0IDg0LjYxMDIgMTUwLjYxMyA4NC42MTAyIDE0OC4wMjYgODguNzgyMyAxNTAuNzggOTMuMjg4MSAxNDkuNDQ1IDkzLjI4ODEgMTQ3Ljg1OSA5MC42MThDMTQ3LjYwOSA5MC4xMTczIDE0Ny4yNzUgODkuNjE2NyAxNDcuMjc1IDg5LjYxNjcgMTQ3LjI3NSA4OS42MTY3IDE0Ny4wMjUgOTAuMTE3MyAxNDYuNzc0IDkwLjYxOEwxNDUuMTg5IDkzLjI4ODEgMTQzLjg1NCA5My4yODgxIDE0Ni42MDggODguNzgyM1oiIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTE1Mi41MzIgODQuNjEwMiAxNTcuNTM4IDg0LjYxMDIgMTU3LjUzOCA4NS42OTQ5IDE1My43IDg1LjY5NDkgMTUzLjcgODguNDQ4NSAxNTYuNzg3IDg4LjQ0ODUgMTU2Ljc4NyA4OS41MzMyIDE1My43IDg5LjUzMzIgMTUzLjcgOTIuMjg2OCAxNTcuNzA1IDkyLjI4NjggMTU3LjcwNSA5My4zNzE2IDE1Mi40NDkgOTMuMzcxNiAxNTIuNDQ5IDg0LjYxMDJaIiBmaWxsPSIjMDAwMDAwIiBmaWxsLXJ1bGU9Im5vbnplcm8iIGZpbGwtb3BhY2l0eT0iMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMS4wMDEwOSA3OSAxOTAuMDk0KSIvPjxwYXRoIGQ9Ik0xNjAuMjA5IDg0LjYxMDIgMTYxLjQ2IDg0LjYxMDIgMTYzLjQ2MyA4OS4yODI5QzE2My42MyA4OS43ODM2IDE2My44OCA5MC40NTExIDE2My44OCA5MC40NTExIDE2My44OCA5MC40NTExIDE2NC4xMyA4OS43ODM2IDE2NC4yOTcgODkuMjgyOUwxNjYuMyA4NC42MTAyIDE2Ny41NTIgODQuNjEwMiAxNjguMjE5IDkzLjI4ODEgMTY3LjA1MSA5My4yODgxIDE2Ni42MzQgODcuODY0NEMxNjYuNjM0IDg3LjM2MzggMTY2LjYzNCA4Ni42MTI4IDE2Ni42MzQgODYuNjEyOCAxNjYuNjM0IDg2LjYxMjggMTY2LjM4MyA4Ny40NDcyIDE2Ni4xMzMgODcuODY0NEwxNjQuMzgxIDkxLjc4NjIgMTYzLjI5NiA5MS43ODYyIDE2MS41NDQgODcuODY0NEMxNjEuMzc3IDg3LjM2MzggMTYxLjA0MyA4Ni41MjkzIDE2MS4wNDMgODYuNTI5MyAxNjEuMDQzIDg2LjUyOTMgMTYxLjA0MyA4Ny4yODAzIDE2MS4wNDMgODcuODY0NEwxNjAuNjI2IDkzLjI4ODEgMTU5LjM3NCA5My4yODgxIDE2MC4yMDkgODQuNjEwMloiIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTE3MC43MjIgODQuNjEwMiAxNzMuNzI2IDg0LjYxMDJDMTc1LjIyOCA4NC42MTAyIDE3Ni4yMjkgODUuNDQ0NiAxNzYuMjI5IDg2Ljc3OTcgMTc2LjIyOSA4Ny42MTQxIDE3NS44MTIgODguMjgxNiAxNzUuMTQ1IDg4LjYxNTQgMTc2LjA2MyA4OC44NjU3IDE3Ni41NjMgODkuNzgzNiAxNzYuNTYzIDkwLjcwMTQgMTc2LjU2MyA5Mi4zNzAzIDE3NS4zMTIgOTMuMjA0NyAxNzMuODEgOTMuMjA0N0wxNzAuNzIyIDkzLjIwNDcgMTcwLjcyMiA4NC42MTAyWk0xNzMuNzI2IDg4LjI4MTZDMTc0LjQ3NyA4OC4yODE2IDE3NC45NzggODcuNjk3NSAxNzQuOTc4IDg2Ljk0NjUgMTc0Ljk3OCA4Ni4xOTU2IDE3NC40NzcgODUuNjk0OSAxNzMuNjQzIDg1LjY5NDlMMTcxLjg5IDg1LjY5NDkgMTcxLjg5IDg4LjI4MTYgMTczLjcyNiA4OC4yODE2Wk0xNzMuODkzIDkyLjIwMzRDMTc0LjgxMSA5Mi4yMDM0IDE3NS4zOTUgOTEuNjE5MyAxNzUuMzk1IDkwLjcwMTQgMTc1LjM5NSA4OS43ODM2IDE3NC44MTEgODkuMTk5NSAxNzMuODkzIDg5LjE5OTVMMTcxLjg5IDg5LjE5OTUgMTcxLjg5IDkyLjExOTkgMTczLjg5MyA5Mi4xMTk5WiIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNMTgyLjU3MSA4NC40NDMzQzE4NS4wNzQgODQuNDQzMyAxODYuOTkzIDg2LjM2MjUgMTg2Ljk5MyA4OC44NjU3IDE4Ni45OTMgOTEuNDUyNCAxODUuMDc0IDkzLjM3MTYgMTgyLjU3MSA5My4zNzE2IDE4MC4wNjggOTMuMzcxNiAxNzguMTQ5IDkxLjM2OSAxNzguMTQ5IDg4Ljg2NTcgMTc4LjE0OSA4Ni4zNjI1IDE4MC4wNjggODQuNDQzMyAxODIuNTcxIDg0LjQ0MzNaTTE4Mi41NzEgOTIuMjg2OEMxODQuMzIzIDkyLjI4NjggMTg1Ljc0MiA5MC43ODQ5IDE4NS43NDIgODguODY1NyAxODUuNzQyIDg2Ljk0NjUgMTg0LjMyMyA4NS41MjggMTgyLjU3MSA4NS41MjggMTgwLjgxOSA4NS41MjggMTc5LjQgODYuOTQ2NSAxNzkuNCA4OC44NjU3IDE3OS40IDkwLjg2ODMgMTgwLjgxOSA5Mi4yODY4IDE4Mi41NzEgOTIuMjg2OFoiIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTE4OC45MTMgODQuNjEwMiAxOTAuMTY0IDg0LjYxMDIgMTkwLjE2NCA5MC4yMDA4QzE5MC4xNjQgOTEuNTM1OSAxOTAuOTk5IDkyLjI4NjggMTkyLjMzNCA5Mi4yODY4IDE5My42NjkgOTIuMjg2OCAxOTQuNTAzIDkxLjUzNTkgMTk0LjUwMyA5MC4yMDA4TDE5NC41MDMgODQuNjEwMiAxOTUuNzU1IDg0LjYxMDIgMTk1Ljc1NSA5MC4yMDA4QzE5NS43NTUgOTIuMTE5OSAxOTQuMzM2IDkzLjQ1NSAxOTIuMzM0IDkzLjQ1NSAxOTAuMzMxIDkzLjQ1NSAxODguOTEzIDkyLjIwMzQgMTg4LjkxMyA5MC4yMDA4TDE4OC45MTMgODQuNjEwMloiIGZpbGw9IiMwMDAwMDAiIGZpbGwtcnVsZT0ibm9uemVybyIgZmlsbC1vcGFjaXR5PSIxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxLjAwMTA5IDc5IDE5MC4wOTQpIi8+PHBhdGggZD0iTTE5OC4xNzUgODQuNjEwMiAyMDAuODQ1IDg0LjYxMDJDMjAxLjc2MyA4NC42MTAyIDIwMi4wOTYgODQuNjkzNiAyMDIuNDMgODQuNzc3MSAyMDMuMzQ4IDg1LjExMDggMjAzLjkzMiA4NS45NDUyIDIwMy45MzIgODcuMTEzNCAyMDMuOTMyIDg4LjE5ODIgMjAzLjM0OCA4OS4xMTYgMjAyLjM0NyA4OS40NDk4IDIwMi4zNDcgODkuNDQ5OCAyMDIuNDMgODkuNTMzMiAyMDIuNTk3IDg5Ljg2N0wyMDQuNDMzIDkzLjIwNDcgMjAzLjA5OCA5My4yMDQ3IDIwMS4yNjIgODkuNzgzNiAxOTkuNDI2IDg5Ljc4MzYgMTk5LjQyNiA5My4yMDQ3IDE5OC4xNzUgOTMuMjA0NyAxOTguMTc1IDg0LjYxMDJaTTIwMS4xNzkgODguNzgyM0MyMDIuMDk2IDg4Ljc4MjMgMjAyLjY4MSA4OC4xOTgyIDIwMi42ODEgODcuMTk2OSAyMDIuNjgxIDg2LjUyOTMgMjAyLjQzIDg2LjExMjEgMjAyLjAxMyA4NS44NjE4IDIwMS43NjMgODUuNzc4NCAyMDEuNTEyIDg1LjY5NDkgMjAwLjg0NSA4NS42OTQ5TDE5OS40MjYgODUuNjk0OSAxOTkuNDI2IDg4Ljc4MjMgMjAxLjE3OSA4OC43ODIzWiIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48cGF0aCBkPSJNMjEwLjE5IDg0LjQ0MzNDMjEyLjI3NiA4NC40NDMzIDIxMy4zNjEgODUuNDQ0NiAyMTMuMzYxIDg1LjQ0NDZMMjEyLjc3NyA4Ni4zNjI1QzIxMi43NzcgODYuMzYyNSAyMTEuNzc2IDg1LjUyOCAyMTAuMzU3IDg1LjUyOCAyMDguMzU1IDg1LjUyOCAyMDcuMTAzIDg3LjAzIDIwNy4xMDMgODguODY1NyAyMDcuMTAzIDkwLjg2ODMgMjA4LjUyMiA5Mi4yODY4IDIxMC4yNzQgOTIuMjg2OCAyMTEuNzc2IDkyLjI4NjggMjEyLjY5NCA5MS4yMDIxIDIxMi42OTQgOTEuMjAyMUwyMTIuNjk0IDg5Ljk1MDUgMjExLjI3NSA4OS45NTA1IDIxMS4yNzUgODguODY1NyAyMTMuNzc4IDg4Ljg2NTcgMjEzLjc3OCA5My4yMDQ3IDIxMi42OTQgOTMuMjA0NyAyMTIuNjk0IDkyLjcwNEMyMTIuNjk0IDkyLjUzNzIgMjEyLjY5NCA5Mi4zNzAzIDIxMi42OTQgOTIuMzcwMyAyMTIuNjk0IDkyLjM3MDMgMjExLjc3NiA5My40NTUgMjEwLjAyMyA5My40NTUgMjA3LjY4NyA5My40NTUgMjA1Ljc2OCA5MS42MTkzIDIwNS43NjggODguOTQ5MiAyMDUuNzY4IDg2LjQ0NTkgMjA3LjYwNCA4NC40NDMzIDIxMC4xOSA4NC40NDMzWiIgZmlsbD0iIzAwMDAwMCIgZmlsbC1ydWxlPSJub256ZXJvIiBmaWxsLW9wYWNpdHk9IjEiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEuMDAxMDkgNzkgMTkwLjA5NCkiLz48L2c+PC9nPjwvZz48L2c+PC9nPjwvc3ZnPg==" alt="InTech — POST Luxembourg Group">
        <div class="report-titles">
          <h1>{{- escapeXML ( index . 0 ).Target }} - Trivy Report </h1>
          <p class="timestamp">{{ now }}</p>
        </div>
      </header>
      <main class="results">
        <div class="table-scroll">
          <table>
          {{- range . }}
            <tr class="group-header"><th colspan="6">{{ .Type | toString | escapeXML }}</th></tr>
            {{- if (eq (len .Vulnerabilities) 0) }}
            <tr><th colspan="6">No Vulnerabilities found</th></tr>
            {{- else }}
            <tr class="sub-header">
              <th>Package</th>
              <th>Vulnerability ID</th>
              <th>Severity</th>
              <th>Installed Version</th>
              <th>Fixed Version</th>
              <th>Links</th>
            </tr>
              {{- range .Vulnerabilities }}
            <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
              <td class="pkg-name">{{ escapeXML .PkgName }}</td>
              <td>{{ escapeXML .VulnerabilityID }}</td>
              <td class="severity">{{ escapeXML .Vulnerability.Severity }}</td>
              <td class="pkg-version">{{ escapeXML .InstalledVersion }}</td>
              <td>{{ escapeXML .FixedVersion }}</td>
              <td class="links" data-more-links="off">
                {{- range .Vulnerability.References }}
                <a href={{ escapeXML . | printf "%q" }}>{{ escapeXML . }}</a>
                {{- end }}
              </td>
            </tr>
              {{- end }}
            {{- end }}
            {{- if (eq (len .Misconfigurations ) 0) }}
            <tr><th colspan="6">No Misconfigurations found</th></tr>
            {{- else }}
            <tr class="sub-header">
              <th>Type</th>
              <th>Misconf ID</th>
              <th>Check</th>
              <th>Severity</th>
              <th>Message</th>
            </tr>
              {{- range .Misconfigurations }}
            <tr class="severity-{{ escapeXML .Severity }}">
              <td class="misconf-type">{{ escapeXML .Type }}</td>
              <td>{{ escapeXML .ID }}</td>
              <td class="misconf-check">{{ escapeXML .Title }}</td>
              <td class="severity">{{ escapeXML .Severity }}</td>
              <td class="link" data-more-links="off"  style="white-space:normal;">
                {{ escapeXML .Message }}
                <br>
                  <a href={{ escapeXML .PrimaryURL | printf "%q" }}>{{ escapeXML .PrimaryURL }}</a>
                </br>
              </td>
            </tr>
              {{- end }}
            {{- end }}
          {{- end }}
          </table>
        </div>
      </main>
    </div>
  </body>
{{- else }}
  </head>
  <body>
    <h1>Trivy Returned Empty Report</h1>
{{- end }}
  </body>
</html>
