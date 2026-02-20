# SimulatingVicsekModel
Final Project from Spring 2022 for computational problem solving in physics

## Files
- `BonavitaFinalProject.m`: Reconstructed MATLAB simulation script from `annotated-BonavitaFinalProject.m.pdf`.
- `annotated-BonavitaFinalProject.m.pdf`: Original annotated PDF source.
- `index.html`, `styles.css`, `app.js`: Browser-based simulation viewer for GitHub Pages.

## Requirements
- MATLAB (or GNU Octave with equivalent functionality)
- `pdist` and `squareform` support (Statistics Toolbox in MATLAB)

## Run
1. Open MATLAB in this project folder.
2. Run:
	```matlab
	BonavitaFinalProject
	```

Part A runs multiple figure-1 style simulations.
Part B sweeps noise values and plots figure-2 style order results.

## Website viewer
Open `index.html` in a browser to run an interactive Vicsek simulation viewer.

Recommended local preview (no extra dependencies):

```bash
python -m http.server 8000
```

Then open `http://localhost:8000`.

The page includes:
- Part A presets (A/B/C/D)
- Custom controls for `L`, `r`, noise, particle count, velocity, and intervals
- Pause/resume and reset

## Publish as `.github.io`
To host the website with GitHub Pages:

1. Push this repo to GitHub.
2. In GitHub, go to **Settings → Pages**.
3. Set **Source** to **Deploy from a branch**.
4. Select branch `main` and folder `/ (root)`.
5. Save, then wait for deployment.

Your site URL will be:
`https://<your-username>.github.io/SimulatingVicsekModel/`

## Push to GitHub
If this folder is not already connected to a remote repo:

```bash
git init
git add .
git commit -m "Add Vicsek MATLAB simulation from annotated project PDF"
git branch -M main
git remote add origin https://github.com/<your-username>/SimulatingVicsekModel.git
git push -u origin main
```
