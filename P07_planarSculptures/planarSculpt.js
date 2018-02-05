// global threejs variables
let container, renderer, camera, scene;
let controls, loader;
let plane;

window.addEventListener('load', onLoad);

function onLoad(){
	container = document.querySelector('#sketch');
	let wid = window.innerWidth;
	let hei = window.innerHeight;

	// THREE INITIALIZATION
	renderer = new THREE.WebGLRenderer({ });
	renderer.setPixelRatio(window.devicePixelRatio);
	renderer.setSize(wid, hei);
	container.appendChild(renderer.domElement);
	scene = new THREE.Scene();
	scene.background = new THREE.Color( 0x111111 );
	camera = new THREE.PerspectiveCamera(50, wid/hei, 0.1, 10000);
	camera.position.set(0, 0, 1);

	controls = new THREE.OrbitControls( camera, renderer.domElement );
	controls.update();

	loader = new THREE.TextureLoader();
	createEnvironment();

	window.addEventListener('resize', onWindowResize, true );

	animate();
}



// EVENTS
function onWindowResize(){
  let wid = window.innerWidth;
  let hei = window.innerHeight;

  renderer.setPixelRatio(window.devicePixelRatio);
  renderer.setSize(wid, hei);
	camera.aspect = wid/hei;
  camera.updateProjectionMatrix();
}



// ANIMATION
function animate(timestamp) {
	renderer.render(scene, camera);
	requestAnimationFrame(animate);

	controls.update();
}



// ENVIRONMENT
function createEnvironment(){
	// SKYDOME
	let sky_geo = new THREE.SphereGeometry(6000, 48, 24);
	let sky_mat = new THREE.MeshLambertMaterial({
		color: 0xffffff,
		side: THREE.DoubleSide,
		// wireframe: true,
	});
	var skydome = new THREE.Mesh(sky_geo, sky_mat);
	scene.add(skydome);

	// PLANE
	let pl_geo = new THREE.PlaneGeometry(500, 500, 100, 100);
	// let pl_mat = new THREE.MeshBasicMaterial({
	let pl_mat = new THREE.MeshPhongMaterial({
		color: 0xf4f5f5,
		// emisive: 0x484948,
		// specular: 0xf4f5f5,
		side: THREE.DoubleSide,
		wireframe: true,
	});
	plane = new THREE.Mesh(pl_geo, pl_mat);

	plane.rotation.x = -Math.PI/2;
	plane.position.set(0, -50, -200);

	scene.add(plane);


	// LIGHTS!
	let d_light = new THREE.DirectionalLight(0xffffff, 0.4);
	scene.add(d_light);

	let p_light = new THREE.PointLight(0xf4f5f5, 1.5, 10000, 2);
	p_light.position.set(0, 1000, 0);
	scene.add(p_light);
}
