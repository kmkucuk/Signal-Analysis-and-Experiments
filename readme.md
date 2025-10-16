# MATLAB EEG Experiments & Analysis

A collection of **psychophysics/RT tasks**, **parallel‑port trigger helpers**, and an **EEG preprocessing & time‑frequency toolbox** for MATLAB. It includes ready‑to‑run experiments (Flanker, Simon, SART, Cued SAM, Checkerboard, Shape task, Visual Gratings, Necker) and analysis utilities (BrainVision import, preprocessing, wavelets/FFT, and factorial ANOVAs).

> Tested with MATLAB R2019a+ on Windows. Psychtoolbox‑3 is recommended for display/timing. Parallel‑port helpers target Windows (InpOutx64/io64).

---

## Folder Structure

```
scripts/
├─ experiments/
│  ├─ cued_sam/                    # Cued Shape-from-Motion / attention task (with analyses)
│  ├─ flanker_task/                # Eriksen flanker variants (keyboard; +_port versions)
│  ├─ gunce_tutorial/              # Timing demos (vbl, etc.)
│  ├─ necker_sam_combined/         # Necker cube + SAM combined experiment
│  ├─ parallel_port/               # io64 wrappers and signal utilities (config_io, outp/inp)
│  ├─ sart/                        # Sustained Attention to Response Task (+ training/spontEEG)
│  ├─ shape_task/                  # Basic shape discrimination task
│  ├─ simon_task/                  # Simon task (+ training)
│  ├─ visual_gratings_aging/       # Grating stimuli & 2IFC variants
│  └─ visualAngleCalculator.m      # Visual angle calculator helper
│
├─ matlab_brainvision/
│  └─ import_bv_mat_file.m         # Import BrainVision-exported .mat into MATLAB structs
│
├─ preprocess/                     # ERP/TF preprocessing helpers (baseline, GA, ISPC, etc.)
├─ signal_analysis/                # Wavelets, FFT, filters, downsampling
├─ statistics/                     # Factorial ANOVA, effect sizes, stat table builders
├─ people/                         # (Aux assets; optional)
├─ plot/                           # (Reserved for plotting utilities)
└─ shape_data/                     # (Aux data; optional)
```

---

## Key Entry Points (Experiments)

> Each task writes behavioral files under `experiments/<task>/behavioralData/<subject>/...`. Port versions additionally send triggers via `parallel_port/` utilities.

- **Flanker Task**  
  - Keyboard only: `experiments/flanker_task/flanker.m`  
  - With triggers: `experiments/flanker_task/flanker_port.m` (500 ms and 1s variants available)

- **Simon Task**  
  - `experiments/simon_task/simon_task.m` (plus `simon_task_training.m`)

- **SART (Go/No‑Go)**  
  - `experiments/sart/sart_experiment.m` (plus `sart_training.m`, `spontaneousEEG.m`)

- **Cued SAM**  
  - Keyboard only / no port: `experiments/cued_sam/new_cued_SAM_keyboard_colorPosition_noPort.m`  
  - Port version: `experiments/cued_sam/new_cued_SAM_port_colorPosition.m`

- **Shape Task**  
  - `experiments/shape_task/shape_task.m` (and `shape_task_sensory.m`)

- **Necker + SAM Combined**  
  - `experiments/necker_sam_combined/necker_sam_combined_experiment.m`

- **Visual Gratings (aging)**  
  - `experiments/visual_gratings_aging/twoIFC.m`, `colored_grating_scriptNEW.m`, etc.

---

## Dependencies

- **MATLAB** R2019a or later (earlier may work).
- **Psychtoolbox‑3** (visual presentation, keyboard, timing): <http://psychtoolbox.org>
- **Parallel port I/O (Windows)**  
  - InpOutx64 or equivalent driver, accessed via `io64` / `outp` / `inp` wrappers under `experiments/parallel_port/`  
  - See: `config_io.m`, `initializeParallelPort.m`, `sendParallelSignal.m`
- **Toolboxes** (recommended): Signal Processing Toolbox.

> For BrainVision `.mat` imports, use `matlab_brainvision/import_bv_mat_file.m` (expects Analyzer‑exported MATLAB files) or adapt to your export format.

---

## Quick Start

1. **Clone & add to path**
   ```matlab
   addpath(genpath(fullfile(pwd, 'scripts')));
   ```

2. **Install Psychtoolbox (if needed)**
   ```matlab
   % From MATLAB Command Window (admin):
   SetupPsychtoolbox
   ```

3. **(Optional) Enable triggers on Windows**
   - Install InpOutx64 driver.
   - Test with:
     ```matlab
     cd('scripts/experiments/parallel_port');
     config_io; initializeParallelPort; sendParallelSignal(1); endParallelSignal;
     ```

4. **Run an experiment**
   ```matlab
   % Flanker (keyboard only)
   run('scripts/experiments/flanker_task/flanker.m');

   % Flanker with triggers
   run('scripts/experiments/flanker_task/flanker_port.m');
   ```

> **Tip:** Many scripts rely on screen calibration and keyboard maps. See helpers such as `KeyboardReg.m`, `screenCalibration.m`, and `visualAngleCalculator.m` under `experiments/`.

---

## Data & Outputs

- **Behavioral**: trial tables (e.g., `*_stimulusTable.txt`), onset logs (`*_stimOnset.txt`), block summaries (`*_block*_info.txt`) are created under `experiments/<task>/behavioralData/<subject>/block_<n>/`.
- **EEG Triggers**: when using `_port` variants, parallel‑port markers are sent at stimulus/response events (check code comments for codes).

---

## EEG Preprocessing & Analysis

**Import**  
- `matlab_brainvision/import_bv_mat_file.m` – loads Analyzer‑exported `.mat` into MATLAB structs.

**Preprocess** (examples)
- `preprocess/createEEG.m`, `CreateStruct.m`, `CreateNewOnset.m`
- `preprocess/baseline_mert.m`, `calculateIAF.m`, `averageROIs.m`, `averageconditions.m`
- `preprocess/computeERPGA.m` (grand average ERPs), `computeISPCGA.m` (phase‑locking / connectivity)
- `preprocess/continuousDataPlot.m`, `computeConvolutionGA.m`

**Signal Analysis**
- Time–frequency: `signal_analysis/wavelet_mert.m`, `eeg_wavelet.m`, `FreqDomainWavelet.m`, `wavelet.m`, `wave_bases.m`
- Spectral/filters: `fftEEG.m`, `filtering_mert.m`, `downSampleStructure.m`

**Statistics**
- `statistics/nestedFactorialANOVA.m`, `createstatsmatrix.m`, `calculateEffectSizeF.m`, `calculateFeffect.m`

---

## Configuration & Customization

- **Keyboard mapping**: `experiments/checkerboard/KeyboardReg.m` and similar helpers.
- **Screen/geometry**: `experiments/*/screenCalibration.m`, `experiments/visualAngleCalculator.m`.
- **Parallel port address**: edit in `parallel_port/config_io.m` or pass via your own wrapper.
- **Instruction screens**: see image assets under each experiment’s `*Instructions/` folder.

---

## Reproducibility Tips

- Use a fixed MATLAB version per study (record it in your paper/notebook).
- Commit your `config_io.m` port address and Psychtoolbox version.
- When running on laptops with high‑DPI displays, disable OS scaling or set Psychtoolbox to high‑precision timing.

---

## Citation

If you use these scripts in published work, please cite the repository and acknowledge the specific tasks/modules you used (e.g., Flanker task with parallel‑port triggers; wavelet‑based time–frequency analysis).

---

## License

Add your preferred license (e.g., MIT).

