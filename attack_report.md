# ModSecurity Attack Analysis Report
Generated on: 02/26/2026 13:08:03

| Status | URI | Rule ID | Message | Matched Data |
| :--- | :--- | :--- | :--- | :--- |
| 403 | `/rest/products/search?q=%27%20OR%201%3D1--` | **942100** | SQL Injection Attack Detected via libinjection | `Matched Data: s&1c found within ARGS:q: ' OR 1=1--` |
| 403 | `/rest/products/search?q=%27%20OR%201%3D1--` | **949110** | Inbound Anomaly Score Exceeded (Total Score: 5) | - |
| 403 | `/rest/products/search?q=<script>alert(1)</script>` | **941100** | XSS Attack Detected via libinjection | `Matched Data: XSS data found within ARGS:q: <script>alert(1)</script>` |
| 403 | `/rest/products/search?q=<script>alert(1)</script>` | **941110** | XSS Filter - Category 1: Script Tag Vector | `Matched Data: <script> found within ARGS:q: <script>alert(1)</script>` |
| 403 | `/rest/products/search?q=<script>alert(1)</script>` | **941160** | NoScript XSS InjectionChecker: HTML Injection | `Matched Data: <script found within ARGS:q: <script>alert(1)</script>` |
| 403 | `/rest/products/search?q=<script>alert(1)</script>` | **941390** | Javascript method detected | `Matched Data: alert( found within ARGS:q: <script>alert(1)</script>` |
| 403 | `/rest/products/search?q=<script>alert(1)</script>` | **949110** | Inbound Anomaly Score Exceeded (Total Score: 20) | - |
| 403 | `/rest/products/search?q=|whoami` | **932235** | Remote Command Execution: Unix Command Injection (command without evasion) | `Matched Data: |whoami found within ARGS:q: |whoami` |
| 403 | `/rest/products/search?q=|whoami` | **932260** | Remote Command Execution: Direct Unix Command Execution | `Matched Data: |whoami found within ARGS:q: |whoami` |
| 403 | `/rest/products/search?q=|whoami` | **932340** | Remote Command Execution: Direct Unix Command Execution (No Arguments) | `Matched Data: |whoami found within ARGS:q: |whoami` |
| 403 | `/rest/products/search?q=|whoami` | **932380** | Remote Command Execution: Windows Command Injection | `Matched Data: |whoami found within ARGS:q: |whoami` |
| 403 | `/rest/products/search?q=|whoami` | **949110** | Inbound Anomaly Score Exceeded (Total Score: 20) | - |
