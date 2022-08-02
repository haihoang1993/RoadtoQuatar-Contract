const download = require('image-downloader');
const data = require('./live.json');
console.log('data:', data)

data.forEach(e => {
    const { home_team: { logo }, away_team: { logo: awLogo } } = e;
    downloadImg(logo);
    downloadImg(awLogo);

})

function downloadImg(url) {

    const options = {
        url: url,
        dest: '../../img',
    };

    download.image(options)
        .then(({ filename }) => {
            console.log('Saved to', filename); // saved to /path/to/dest/image.jpg
        })
        .catch((err) => console.error(err));
}
