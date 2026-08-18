import { useEffect, useState } from 'react'
import './App.css'

const API_URL = 'http://localhost:5000'

function App() {
  const [token, setToken] = useState(localStorage.getItem('clinicToken') || '')
  const [doctor, setDoctor] = useState(null)
  const [queue, setQueue] = useState([])
  const [currentToken, setCurrentToken] = useState(null)
  const [waitingCount, setWaitingCount] = useState(0)
  const [status, setStatus] = useState('INACTIVE')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [loginForm, setLoginForm] = useState({
    email: 'doctor@clinic.com',
    password: 'password123',
  })

  const apiRequest = async (url, options = {}) => {
    const response = await fetch(`${API_URL}${url}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...(options.headers || {}),
      },
    })

    const result = await response.json()

    if (!response.ok) {
      throw new Error(result.message || 'Request failed')
    }

    return result.data ?? result
  }

  const loadDashboard = async () => {
    if (!token) return

    setLoading(true)
    setError('')

    try {
      const doctorProfile = await apiRequest('/api/doctors/me')
      const doctorStatus = await apiRequest('/api/doctors/me/status')
      const queueData = await apiRequest('/api/doctors/me/queue')

      setDoctor(doctorProfile)
      setStatus(doctorStatus.status)
      setCurrentToken(queueData.currentToken)
      setWaitingCount(queueData.waitingCount || 0)
      setQueue(queueData.queue || [])
    } catch (err) {
      setError(err.message)
      setToken('')
      localStorage.removeItem('clinicToken')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    if (token) {
      loadDashboard()
    }
  }, [token])

  const handleLogin = async (event) => {
    event.preventDefault()
    setError('')
    setLoading(true)

    try {
      const result = await apiRequest('/api/auth/doctor/login', {
        method: 'POST',
        body: JSON.stringify(loginForm),
      })

      const nextToken = result.token
      setToken(nextToken)
      localStorage.setItem('clinicToken', nextToken)
      setDoctor(result.doctor)
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const handleNextToken = async () => {
    try {
      await apiRequest('/api/doctors/me/queue/next', { method: 'POST' })
      await loadDashboard()
    } catch (err) {
      setError(err.message)
    }
  }

  const handleToggleStatus = async () => {
    const nextStatus = status === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'

    try {
      await apiRequest('/api/doctors/me/status', {
        method: 'PATCH',
        body: JSON.stringify({ status: nextStatus }),
      })
      setStatus(nextStatus)
    } catch (err) {
      setError(err.message)
    }
  }

  const handleCancel = async (tokenId) => {
    try {
      await apiRequest(`/api/tokens/${tokenId}/cancel`, {
        method: 'PATCH',
      })
      await loadDashboard()
    } catch (err) {
      setError(err.message)
    }
  }

  const handleLogout = () => {
    setToken('')
    setDoctor(null)
    setQueue([])
    setCurrentToken(null)
    setWaitingCount(0)
    setStatus('INACTIVE')
    localStorage.removeItem('clinicToken')
  }

  if (!token) {
    return (
      <div className="login-shell">
        <form className="login-card" onSubmit={handleLogin}>
          <p className="eyebrow">Clinic portal</p>
          <h1>Doctor Login</h1>

          <label>
            <span>Email</span>
            <input
              type="email"
              value={loginForm.email}
              onChange={(event) => setLoginForm({ ...loginForm, email: event.target.value })}
            />
          </label>

          <label>
            <span>Password</span>
            <input
              type="password"
              value={loginForm.password}
              onChange={(event) => setLoginForm({ ...loginForm, password: event.target.value })}
            />
          </label>

          {error && <div className="error-banner">{error}</div>}

          <button type="submit" className="primary-btn full-width" disabled={loading}>
            {loading ? 'Signing in...' : 'Login'}
          </button>
        </form>
      </div>
    )
  }

  return (
    <div className="dashboard-shell">
      <header className="topbar">
        <div className="brand-block">
          <div className="logo-mark">C</div>
          <div>
            <p className="eyebrow">Clinic Queue</p>
            <h2>{doctor?.name || 'Doctor'}</h2>
          </div>
        </div>

        <div className="topbar-actions">
          <div className="status-box">
            <span className="status-label">Availability</span>
            <button
              className={`toggle ${status === 'ACTIVE' ? 'active' : ''}`}
              type="button"
              onClick={handleToggleStatus}
            >
              <span className="toggle-dot" />
              {status}
            </button>
          </div>
          <button className="logout-btn" type="button" onClick={handleLogout}>Logout</button>
        </div>
      </header>

      <main className="dashboard-main">
        <section className="welcome-row">
          <div>
            <p className="muted">Good morning</p>
            <h1>Today’s queue</h1>
          </div>
        </section>

        {error && <div className="error-banner margin-bottom">{error}</div>}

        <section className="stats-grid">
          <article className="stat-card dark">
            <span>Now Serving</span>
            <strong>#{currentToken ?? '—'}</strong>
            <small>{doctor?.specialization || 'General clinic'}</small>
          </article>

          <article className="stat-card">
            <span>Waiting</span>
            <strong>{waitingCount}</strong>
          </article>

          <article className="stat-card">
            <span>Completed</span>
            <strong>{queue.filter((item) => item.status === 'COMPLETED').length}</strong>
          </article>
        </section>

        <section className="current-patient-panel">
          <div>
            <p className="muted">Current patient</p>
            <h3>{currentToken ? `Token #${currentToken}` : 'No active patient'}</h3>
            <p className="patient-name">
              {queue.find((item) => item.tokenNumber === currentToken)?.patientName || 'Waiting for next patient'}
            </p>
          </div>
          <button type="button" className="primary-btn" onClick={handleNextToken} disabled={loading}>
            {loading ? 'Loading...' : 'Next Token'}
          </button>
        </section>

        <section className="queue-panel">
          <div className="section-header">
            <h3>Queue</h3>
          </div>

          <div className="queue-table">
            <div className="queue-head queue-row">
              <span>Token</span>
              <span>Patient</span>
              <span>Status</span>
              <span>Action</span>
            </div>

            {queue.length === 0 ? (
              <div className="queue-row empty-row">
                <span>No patients waiting</span>
              </div>
            ) : (
              queue.map((item) => (
                <div className="queue-row" key={item.tokenId}>
                  <span className="token-number">#{item.tokenNumber}</span>
                  <span>{item.patientName}</span>
                  <span className="status-tag">{item.status}</span>
                  <button
                    type="button"
                    className="cancel-btn"
                    onClick={() => handleCancel(item.tokenId)}
                  >
                    Cancel
                  </button>
                </div>
              ))
            )}
          </div>
        </section>
      </main>
    </div>
  )
}

export default App
