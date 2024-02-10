window.secondsToTimeFormat = function(totalSeconds) {
  let hours = Math.floor(totalSeconds / 3600);
  let minutes = Math.floor((totalSeconds % 3600) / 60);
  let seconds = Math.round(totalSeconds % 60);

  if (seconds === 60) {
    minutes += 1;
    seconds = 0;
  }

  if (minutes === 60) {
    hours += 1;
    minutes = 0;
  }

  function padWithLeadingZero(number) {
    return number < 10 ? '0' + number : number;
  }

  let formatString = '';
  if (hours > 0) {
    formatString += `${padWithLeadingZero(hours)}:`;
  }
  formatString += `${padWithLeadingZero(minutes)}:`;
  formatString += padWithLeadingZero(seconds);

  return formatString.trim();
}