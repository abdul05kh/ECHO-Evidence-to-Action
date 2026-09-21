# ECHO — Evidence Capture & Handoff Orchestrator

> **Turn what a worker sees and says into a verified unit of work — on the phone, offline, and ready for the laptop.**

**Track:** Track 04 — Productivity (iQOO Hackathon 2026)  
**Primary Demo Domain:** Campus & Facility Operations  
**Reference Scenario:** Lab 2 Projector Power Failure  

---

## Non-Negotiable Architectural Principles

1. **Phone-First (Real Flutter + Android)**: The phone is the primary work surface. Built in Flutter + Dart with Kotlin Android bridge.
2. **Local-First & Offline-Capable**: SQLite + Drift local database. Zero cloud dependency required for capturing, structuring, verifying, or executing work.
3. **Structured AI (Action Packet)**: AI is structural, not a decorative chatbot. Output is validated against a strict JSON schema contract before persistence.
4. **Mandatory Human Approval Gate**: AI never silently activates or executes tasks. Operators verify and approve every Action Packet.
5. **Evidence Provenance Trace**: Every observed fact and AI inference links directly to supporting media clips (photos, audio timestamps, transcript excerpts).
6. **Deterministic Policy Engine**: Operational priority is decided by a deterministic rule engine (safety hazards, timing deadlines, disruption), not raw LLM hallucination.
7. **Explicit Missing Information**: Missing operational facts are explicitly requested, never fabricated.
8. **Office Kit Handoff Boundary**: Transfers `.echopack.json` and clipboard payloads from phone to laptop supervisor workspace without retyping.
9. **Strict Light Theme Only**: High-contrast, premium operational light theme (`#F7F9FC` background, `#FFFFFF` cards, `#0F172A` deep slate text, `#E5A000` iQOO warm gold, and `#2563EB` action blue). Zero dark mode.

---

## First Vertical Slice Architecture

```
mobile/
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml (Camera, Microphone, Storage permissions)
│       └── kotlin/com/echo/orchestrator/MainActivity.kt (Native hardware & Office Kit bridge)
├── lib/
│   ├── app/
│   │   └── theme.dart (Strict Light Theme Design System)
│   ├── core/
│   │   └── storage/
│   │       └── local_db.dart (Drift / SQLite Local Tables)
│   ├── features/
│   │   ├── ai/
│   │   │   ├── model_adapter.dart (ModelAdapter, Runtime Status, Safe Fallback)
│   │   │   ├── policy_engine.dart (Deterministic Priority Rule Engine)
│   │   │   └── schema_validator.dart (JSON Schema Validation)
│   │   ├── bridge/
│   │   │   └── office_kit_bridge.dart (Office Kit Packet & Clipboard Handoff)
│   │   ├── capture/
│   │   │   └── presentation/
│   │   │       ├── audio_recorder_widget.dart (Real Audio Recording & Playback)
│   │   │       ├── camera_screen.dart (Real Android Camera Preview & Capture)
│   │   │       ├── capture_view.dart (Capture Orchestration)
│   │   │       └── processing_screen.dart (Honest 5-Step Pipeline Stepper)
│   │   ├── home/
│   │   │   └── home_queue_screen.dart (Heartbeat Home Screen with + CAPTURE CTA)
│   │   ├── packet/
│   │   │   ├── domain/
│   │   │   │   └── action_packet.dart (ActionPacket Domain Entity)
│   │   │   └── presentation/
│   │   │       ├── action_packet_screen.dart (Centerpiece Action Packet View)
│   │   │       ├── evidence_provenance_modal.dart (Interactive Evidence Trace)
│   │   │       └── missing_info_card.dart (Explicit Missing Information)
│   │   └── tasks/
│   │       └── domain/
│   │           └── task_state_machine.dart (Task Lifecycle State Machine)
│   └── main.dart
├── test/
│   ├── model_adapter_test.dart (Grounded generation, Fallback, Status)
│   ├── office_kit_bridge_test.dart (JSON serialization, Markdown export)
│   ├── policy_engine_test.dart (Safety keywords, Deadlines, Routine rules)
│   └── schema_validator_test.dart (JSON validation, State transitions)
└── pubspec.yaml
```

---

## Verification & Test Results

All 14 automated unit tests passing cleanly:
- `Deterministic PolicyEngine Tests`: Safety critical keywords ($\to$ `critical`), 20-min class deadline ($\to$ `high`), routine checks ($\to$ `low`).
- `SchemaValidator Tests`: Valid JSON structure passes; missing title or malformed JSON properly caught.
- `TaskStateMachine Lifecycle Tests`: Valid state transitions (`draft` $\to$ `processing` $\to$ `ready` $\to$ `approved` $\to$ `in_progress` $\to$ `completed` $\to$ `reopened`) verified; illegal jumps blocked.
- `EchoModelAdapter Tests`: Prototype mode generates grounded Action Packet with evidence citations, explicit missing information cards, and checklist. Safe fallback mode verified.
- `OfficeKitBridge Tests`: `.echopack.json` schema export and formatted Markdown summaries verified.
