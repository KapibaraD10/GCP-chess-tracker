import { useState } from 'react'
import './App.css'

function App() {
  const [username, setUsername] = useState('')
  const [userData, setUserData] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const fetchUser = async (e) => {
    e.preventDefault()
    if (!username) return

    setLoading(true)
    setError(null)
    setUserData(null)

    try {
      // In production, this is served from the same origin.
      // In local dev, we might need a proxy or full URL if ports differ.
      // For now assuming relative path /api/ works (setup in docker/proxy).
      const baseUrl = import.meta.env.DEV ? 'http://localhost:8080' : '';
      const response = await fetch(`${baseUrl}/api/user/${username}`)

      if (!response.ok) {
        throw new Error('User not found or API error')
      }

      const data = await response.json()
      setUserData(data)
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="app-container">
      <h1>GCP Chess Tracker</h1>
      <form onSubmit={fetchUser} className="search-form">
        <input
          type="text"
          placeholder="Enter Lichess Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          className="search-input"
        />
        <button type="submit" disabled={loading} className="search-button">
          {loading ? 'Searching...' : 'Search'}
        </button>
      </form>

      {error && <div className="error-message">{error}</div>}

      {userData && (
        <div className="user-card">
          <h2>{userData.username}</h2>
          {userData.profile && (
            <div className="profile-info">
              <p>Name: {userData.profile.firstName} {userData.profile.lastName}</p>
              <p>Country: {userData.profile.country}</p>
            </div>
          )}
          <div className="stats-grid">
            <div className="stat-item">
              <h3>Blitz</h3>
              <p>{userData.perfs?.blitz?.rating || 'N/A'}</p>
              <small>{userData.perfs?.blitz?.games || 0} games</small>
            </div>
            <div className="stat-item">
              <h3>Rapid</h3>
              <p>{userData.perfs?.rapid?.rating || 'N/A'}</p>
              <small>{userData.perfs?.rapid?.games || 0} games</small>
            </div>
            <div className="stat-item">
              <h3>Bullet</h3>
              <p>{userData.perfs?.bullet?.rating || 'N/A'}</p>
              <small>{userData.perfs?.bullet?.games || 0} games</small>
            </div>
            <div className="stat-item">
              <h3>Puzzle</h3>
              <p>{userData.perfs?.puzzle?.rating || 'N/A'}</p>
            </div>
          </div>
          <p className="status">
            Status: {userData.online ? <span className="online">Online</span> : 'Offline'}
          </p>
          <a href={userData.url} target="_blank" rel="noopener noreferrer" className="profile-link">
            View on Lichess
          </a>
        </div>
      )}
    </div>
  )
}

export default App
